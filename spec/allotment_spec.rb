require './helpers/allotment_helper'
require 'time'

describe 'test_allotment_helper' do
    allotment_1 = { time_until_grown: nil } # empty
    allotment_2 = { time_until_grown: Time.now - 60 } # grown
    allotment_3 = { time_until_grown: Time.now + 60 } # growing

    describe 'check_allotment_status' do
        it "Checks if the allotment is empty" do
            response = check_allotment_status(allotment_1)
            expect(response).to eq('empty')
        end
        it 'Checks if the allotment is grown' do
            response = check_allotment_status(allotment_2)
            expect(response).to eq('ready')
        end
        it 'Checks if the allotment is growing' do
            response = check_allotment_status(allotment_3)
            expect(response).to eq('not_ready')
        end
    end
end
