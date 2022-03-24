class Farm

    def initialize(name, farmers_name)
        @name = name
        @farmers_name = farmers_name
        @inventory = {
            seed_packet: 1,
            # fertilizer: 0,
            produce: 0
        }
        @allotments = [
            {
                time_until_grown: nil, # Time.now + 60 # current time + 1 minute
                produce_type: nil # eg corn, carrot, tomato, grapes
                # fertilized: false,
                # watered: false
            }
        ]
    end
end
