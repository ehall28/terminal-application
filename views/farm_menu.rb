
class FarmMenu
    def initialize(farm)
        @farm = farm
        @prompt = TTY::Prompt.new
        @crow = CrowMenu.new

        farm_menu()
    end

    def farm_menu
        loop do
            TH.clear()

            choices = [
                { name: "View allotments", value: 1 },
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
            TH.clear()

            choices = [{ name: 'Refresh', value: 1 }]
            @farm.allotments.each_with_index do |allotment, index|
                status = AllotmentHelper.check_allotment_status(allotment)
                fancy_name = allotment[:produce_type].to_s.capitalize

                case status
                when 'empty'
                    choices.push({ name: "Allotment #{index + 1} - Empty", value: allotment })
                when 'ready'
                    choices.push({ name: "Allotment #{index + 1} - #{fancy_name} - Ready", value: allotment })
                when 'not_ready'
                    time_diff = allotment[:time_until_grown] - Time.now
                    minutes, seconds = time_diff.divmod(60)
                    grow_text = "(#{minutes}m:#{seconds.to_i}s)"
                    choices.push({ name: "Allotment #{index + 1} - #{fancy_name} -", value: allotment, disabled: grow_text })
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
        TH.clear()

        status = AllotmentHelper.check_allotment_status(allotment)

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

            minutes, seconds = PlantHelper.grow_time(seed_name).divmod(60)
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

        # crow encounter
        if rand(1..5) == 1
            @crow.crow_encounter(allotment)
        else
            allotment[:produce_type] = seed_name
            allotment[:time_until_grown] = Time.now + PlantHelper.grow_time(seed_name)

            # overwrites grow time to the time.now if cheats are enabled
            allotment[:time_until_grown] = Time.now if @farm.cheats_enabled?
        end

        seed_data[:amount] -= 1
        @farm.save_data
    end

    def harvest(allotment)
        TH.clear()
        # To access seed data by produce_type it needs to be a symbol
        # Error arrises because saved game stores produce_type as a string - after loading produce_type is a string
        seed_name = allotment[:produce_type].to_sym
        harvest_amount = (PlantHelper.modifier(seed_name) * rand(1..10)).to_i
        @farm.inventory[:produce] += harvest_amount
        puts "You harvest #{harvest_amount} x #{seed_name.to_s.capitalize} #{PlantHelper.emoji(seed_name)}"
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
