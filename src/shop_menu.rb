class ShopMenu
    def initialize(farm)
        @farm = farm
        @prompt = TTY::Prompt.new
        shop_menu()
    end

    def shop_menu()
        loop do
            clear()
            choices = [
                { name: 'Buy seeds', value: 1 },
                { name: 'Sell produce', value: 2 },
                { name: 'Buy allotments', value: 3, disabled: '(Coming Soon!)' },
                { name: 'Back', value: 4 }
            ]

            choices[1][:disabled] = '(No produce available)' unless @farm.inventory[:produce].positive?

            puts "Available gold: #{@farm.inventory[:gold]}g"
            response = @prompt.select("What would you like to do?", choices)

            case response
            when 1
                buy_seeds_menu()
            when 2
                sell_menu()
            when 4
                return
            end
        end
    end

    def buy_seeds_menu()
        loop do
            clear()
            choices = []

            PlantHelper::PLANT_DATA.each do |seed|
                seed_name, seed_data = seed
                minutes, seconds = PlantHelper.grow_time(seed_name).divmod(60)
                fancy_name = "#{seed_name} seeds".capitalize.ljust(12)

                seed_amount = 0

                unless @farm.inventory[:seeds][seed_name].nil?
                    seed_amount = @farm.inventory[:seeds][seed_name][:amount]
                end

                seed_display = { name: "#{fancy_name} - #{seed_data[:cost]}g - Amount: #{seed_amount} - Grow Time: #{minutes}m:#{seconds}s", value: seed }
                if @farm.inventory[:gold] < seed_data[:cost]
                    seed_display[:disabled] = "(Not enough gold)"
                end

                choices.push(seed_display)
            end
            choices.push({ name: 'Back', value: 1 })
            puts "Available gold: #{@farm.inventory[:gold]}g"
            response = @prompt.select("What would you like to do?", choices)

            break if response == 1
            seed_name, seed_data = response
            @farm.inventory[:gold] -= seed_data[:cost]

            # for buying things first time - player wont have seed
            if @farm.inventory[:seeds][seed_name].nil?
                @farm.inventory[:seeds][seed_name] = { amount: 0 }
            end
            @farm.inventory[:seeds][seed_name][:amount] += 1
            @farm.save_data
        end
    end

    def sell_menu
        produce_amount = @farm.inventory[:produce]
        gold_earnt = 10 * produce_amount
        @farm.inventory[:gold] += gold_earnt
        @farm.inventory[:produce] = 0
        puts "You have sold #{produce_amount} x produce for #{gold_earnt}g"
        @farm.save_data
        @prompt.keypress('Press any key to continue...')
    end
end
