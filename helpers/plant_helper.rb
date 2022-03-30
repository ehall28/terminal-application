module PlantHelper
    PLANT_DATA = {
        tomato: {
            grow_time_sec: 10,
            cost: 10,
            modifier: 1,
            emoji: '🍅'
        },
        corn: {
            grow_time_sec: 30,
            cost: 30,
            modifier: 1.5,
            emoji: '🌽'
        },
        carrot: {
            grow_time_sec: 60,
            cost: 50,
            modifier: 3,
            emoji: '🥕'
        }
    }

    def grow_time(plant)
        return PLANT_DATA[plant.to_sym][:grow_time_sec]
    end

    def cost(plant)
        return PLANT_DATA[plant.to_sym][:cost]
    end

    def modifier(plant)
        return PLANT_DATA[plant.to_sym][:modifier]
    end

    def emoji(plant)
        return PLANT_DATA[plant.to_sym][:emoji]
    end
end
