class Farm
    attr_accessor :name, :farmers_name, :inventory, :allotments

    def initialize()
        @name = ''
        @farmers_name = ''
        @inventory = {
            seeds: {},
            # fertilizer: 0,
            produce: 0,
            gold: 20
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

    def save_data()
        save = {
            name: @name,
            farmers_name: @farmers_name,
            inventory: @inventory,
            allotments: @allotments
        }
        File.write('save_data.json', JSON.pretty_generate(save))
    end

    def load_data()
        file = File.read('save_data.json')
        data_hash = JSON.parse(file, symbolize_names: true)

        @name = data_hash[:name]
        @farmers_name = data_hash[:farmers_name]
        @inventory = data_hash[:inventory]
        @allotments = data_hash[:allotments].map do |allotment|
            {
                produce_type: allotment[:produce_type],
                # way to convert time as a string to time - saves to json as a string
                time_until_grown: allotment[:time_until_grown].nil? ? nil : Time.parse(allotment[:time_until_grown])
            }
        end
    end
end
