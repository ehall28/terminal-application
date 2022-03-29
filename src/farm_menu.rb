
class FarmMenu
    def initialize(farm)
        @farm = farm
        @prompt = TTY::Prompt.new

        farm_menu()
    end

    def farm_menu
        loop do
            clear()

            choices = [
                { name: "View allotments", value: 1 }, # , disabled: "()"
                { name: "View inventory", value: 2 },
                { name: "Go to shop", value: 3 },
                { name: "Exit", value: 4 }
            ]
            response = @prompt.select("What would you like to do on your farm, #{@farm.farmers_name}", choices)

            case response
            when 1
                allotment_menu()
            when 2
                inventory()
            when 3
                ShopMenu.new(@farm)
            when 4
                @farm.save_data
                puts 'Bye! See you soon!'
                break # Save and quit
            end
        end
    end

    def allotment_menu
        loop do
            clear()

            choices = [{ name: 'Refresh', value: 1 }]
            @farm.allotments.each_with_index do |allotment, index|
                status = check_allotment_status(allotment)

                case status
                when 'empty'
                    choices.push({ name: "Allotment #{index + 1} - Empty", value: allotment })
                when 'ready'
                    choices.push({ name: "Allotment #{index + 1} - #{allotment[:produce_type]} - Ready", value: allotment })
                when 'not_ready'
                    time_diff = allotment[:time_until_grown] - Time.now
                    minutes, seconds = time_diff.divmod(60)
                    grow_text = "(#{minutes}m:#{seconds.to_i}s)"
                    choices.push({ name: "Allotment #{index + 1} - #{allotment[:produce_type]} -", value: allotment, disabled: grow_text })
                end
            end

            choices.push({ name: "Back", value: 2 })
            response = @prompt.select("Allotment menu", choices)

            case response
            when 1 # user refreshes
                next
            when 2 # user wants to go back
                break
            else # user selects an allotment
                determine_menu(response)
            end
        end
    end

    def determine_menu(allotment)
        clear()

        status = check_allotment_status(allotment)

        case status
        when 'empty'
            plant_menu(allotment)
        when 'ready'
            harvest(allotment)
        when 'not_ready'
            growing_menu()
        end
    end

    def plant_menu(allotment)
        choices = [
            { name: "Plant seed", value: 1 }, # , disabled: "()"
            { name: "Water crop", value: 2, disabled: "(Coming soon!)" },
            { name: "Fertilize crop", value: 3, disabled: "(Coming soon!)" },
            { name: "Back", value: 4 }
        ]
        response = @prompt.select("What would you like to do with your allotment, #{@farm.farmers_name}?", choices)

        case response
        when 1
            select_seed_menu(allotment)
        when 2
            # will water crop
        when 3
            # will fertilize crop - increase yield
        when 4
            return
        end
    end

    def select_seed_menu(allotment)
        choices = []

        @farm.inventory[:seeds].each do |seed| # Seed will be an array with 2 elements, first element is the key, second is the value
            seed_name, seed_data = seed # e.g. [:tomato { :amount=>1 }]

            fancy_name = seed_name.to_s.ljust(6).capitalize # .ljust(6) will add spaces to be atleast 6 characters long

            minutes, seconds = SeedHelper::SEED_DATA[seed_name][:grow_time_sec].divmod(60)
            seed_display = { name: "#{fancy_name} - Amount: #{seed_data[:amount]} - Grow Time: #{minutes}m:#{seconds}s", value: seed }

            if seed_data[:amount] < 1
                seed_display[:disabled] = ''
            end

            choices.push(seed_display)
        end

        choices.push({ name: 'Back', value: 1 })
        response = @prompt.select("What would you like to plant?", choices)

        return if response == 1

        seed_name, seed_data = response # e.g. [:tomato, { amount: 0 }]

        allotment[:produce_type] = seed_name.to_s.capitalize
        allotment[:time_until_grown] = Time.now + SeedHelper::SEED_DATA[seed_name][:grow_time_sec]

        # overwrites grow time to the time.now if cheats are enabled
        allotment[:time_until_grown] = Time.now if @farm.cheats_enabled?

        seed_data[:amount] -= 1
        @farm.save_data
    end

    def harvest(allotment)
        clear()
        harvest_amount = produce_modifier(allotment[:produce_type])
        @farm.inventory[:produce] += harvest_amount
        puts "You harvest #{harvest_amount} x #{allotment[:produce_type]}"
        allotment[:time_until_grown] = nil
        allotment[:produce_type] = nil
        @farm.save_data
        @prompt.keypress('Press any key to continue...')
    end

    def inventory()
        puts "Available gold: #{@farm.inventory[:gold]}g"
        puts "The amount of produce you have is #{@farm.inventory[:produce]}"

        @farm.inventory[:seeds].each do |key, value|
            puts "Available seeds - #{key.capitalize}: #{value[:amount]}"
        end

        @prompt.keypress('Press any key to continue...')
    end
end
