class ShopMenu
    def initialize
        @farm = farm
        @prompt = TTY::Prompt.new
    end

    def shop_menu
        choices = [
            { name: 'Buy seeds', value: 1 },
            { name: 'Sell produce', value: 2 },
            { name: 'Back', value: 3 }
        ]

        response = @prompt.select("What would you like to do?", choices)

        case response
        when 1
            buy_menu()
        when 2
            sell_menu()
        when 3
            break
        end
    end

    def buy_menu
    end

    def sell_menu
    end


end
