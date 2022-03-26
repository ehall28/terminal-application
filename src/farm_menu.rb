
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
                { name: "Go to shop", value: 3, disabled: "(Coming soon!)" },
                { name: "Exit", value: 4 }
            ]
            response = @prompt.select("What would you like to do on your farm, #{@farm.farmers_name}", choices)

            case response
            when 1
                allotment_menu()
            when 2
                # opens inventory
            when 3
                # Goes to the shop
            when 4
                # Save and quit
            when 5
                # return to previous menu
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
            harvest_menu()
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

    # TODO Add logic to disable 0 seeds
    def select_seed_menu(allotment)
        choices = []

        @farm.inventory[:seeds].each do |seed_name, seed_data|
            name = seed_name.to_s.ljust(6).capitalize # .ljust(6) will add spaces to be atleast 6 characters long
            minutes, seconds = seed_data[:grow_time_sec].divmod(60)
            seed_display = { name: "#{name} - Amount: #{seed_data[:amount]}, Grow Time: #{minutes}m:#{seconds}s", value: seed_data }
            if seed_data[:amount] < 1
                seed_display[:disabled] = ''
            end

            choices.push(seed_display)
        end

        choices.push({ name: 'Back', value: 1 })
        response = @prompt.select("What would you like to plant?", choices)

        if response != 1
            allotment[:time_until_grown] = Time.now + response[:grow_time_sec]
            allotment[:produce_type] = response[:name]
            response[:amount] -= 1
        end
    end

    def harvest_menu
    end

    def growing_menu
    end
end
