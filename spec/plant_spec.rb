require './helpers/plant_helper'
include PlantHelper

describe 'test_plant_helper' do
    describe 'Helper to get data from PLANT_DATA' do
        it "Checks if the grow_time in PLANT_DATA is correct" do
            tomato = PlantHelper.grow_time(:tomato)
            corn = PlantHelper.grow_time(:corn)
            carrot = PlantHelper.grow_time(:carrot)

            expect(tomato).to eq(10)
            expect(corn).to eq(30)
            expect(carrot).to eq(60)
        end

        it "Checks if the cost in PLANT_DATA is correct" do
            tomato = PlantHelper.cost(:tomato)
            corn = PlantHelper.cost(:corn)
            carrot = PlantHelper.cost(:carrot)

            expect(tomato).to eq(10)
            expect(corn).to eq(30)
            expect(carrot).to eq(50)
        end

        it "Checks if the modifier in PLANT_DATA is correct" do
            tomato = PlantHelper.modifier(:tomato)
            corn = PlantHelper.modifier(:corn)
            carrot = PlantHelper.modifier(:carrot)

            expect(tomato).to eq(1)
            expect(corn).to eq(1.5)
            expect(carrot).to eq(3)
        end

        it "Checks if the emoji in PLANT_DATA is correct" do
            tomato = PlantHelper.emoji(:tomato)
            corn = PlantHelper.emoji(:corn)
            carrot = PlantHelper.emoji(:carrot)

            expect(tomato).to eq('🍅')
            expect(corn).to eq('🌽')
            expect(carrot).to eq('🥕')
        end
    end
end
