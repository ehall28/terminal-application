class Farm
    attr_reader :name, :farmers_name
    attr_accessor :inventory, :allotments

    def initialize(name, farmers_name)
        @name = name
        @farmers_name = farmers_name
        @inventory = {
            seeds: { 
                tomato: {
                    amount: 1,
                    grow_time_sec: 300, # 5 minutes
                },
                corn: {
                    amount: 0,
                    grow_time_sec: 300,
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
                time_until_grown: Time.now + 15, # Time.now + 60 # current time + 1 minute
                produce_type: "Carrot" # eg corn, carrot, tomato, grapes
                # fertilized: false,
                # watered: false
            },
            {
                time_until_grown: Time.now - 60, # Time.now + 60 # current time + 1 minute
                produce_type: "Corn" # eg corn, carrot, tomato, grapes
                # fertilized: false,
                # watered: false
            }
        ]
    end
end
