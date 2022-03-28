class ShopMenu
    def initialize(farm)
        @farm = farm
        @prompt = TTY::Prompt.new
        shop_menu()
    end

    def shop_menu()
        clear()
        choices = [
            { name: 'Buy seeds', value: 1 },
            { name: 'Sell produce', value: 2 },
            { name: 'Buy allotments', value: 3, disabled: '(Coming Soon!)' },
            { name: 'Back', value: 4 }
        ]
        puts "Available gold: #{@farm.inventory[:coins]}g"
        response = @prompt.select("What would you like to do?", choices)

        case response
        when 1
            buy_seeds_menu()
        when 2
            sell_menu()
        when 3
            return
        end
    end

    def buy_seeds_menu()
        loop do
            clear()
            choices = [
                { name: "Tomato seeds, 10g - owned #{@farm.inventory[:seeds][:tomato][:amount]}", value: 1 },
                { name: "Corn seeds, 20g - owned #{@farm.inventory[:seeds][:corn][:amount]}", value: 2 },
                { name: 'Back', value: 3 }
            ]
            puts "Available gold: #{@farm.inventory[:coins]}g"
            response = @prompt.select("What would you like to do?", choices)

            case response
            when 1
                puts "You purchased 1 tomato seed"
            when 2
                puts "You purchased 1 corn seed"
            when 3
                return
            end
        end
    end

    def sell_menu
    end

end
