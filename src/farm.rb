class Farm
    attr_reader :name, :farmers_name
    attr_accessor :inventory, :allotments

    def initialize(name, farmers_name)
        @name = name
        @farmers_name = farmers_name
        @inventory = {
            seeds: { 
                tomato: {
                    name: 'Tomato',
                    amount: 1,
                    grow_time_sec: 10, # seconds
                },
                corn: {
                    name: 'Corn',
                    amount: 0,
                    grow_time_sec: 300, # 5 minutes in seconds
                },
                # carrot: {}

            },
            # fertilizer: 0,
            produce: 0
        }
        @allotments = [
            {
                time_until_grown: nil, # Time.now + 60 # current time + 1 minute
                produce_type: nil # eg corn, carrot, tomato, grapes
                # fertilized: false,
                # watered: false
            },
            {
                time_until_grown: nil, # Time.now + 60 # current time + 1 minute
                produce_type: nil # eg corn, carrot, tomato, grapes
                # fertilized: false,
                # watered: false
            }
        ]
    end
end
