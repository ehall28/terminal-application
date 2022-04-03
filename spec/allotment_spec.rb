require './helpers/allotment_helper'
require 'time'
include AllotmentHelper

describe 'test_allotment_helper' do
    allotment1 = { time_until_grown: nil } # empty
    allotment2 = { time_until_grown: Time.now - 60 } # grown
    allotment3 = { time_until_grown: Time.now + 60 } # growing

    describe 'check_allotment_status' do
        it "Checks if the allotment is empty" do
            response = AllotmentHelper.check_allotment_status(allotment1)
            expect(response).to eq('empty')
        end

        it 'Checks if the allotment is grown' do
            response = AllotmentHelper.check_allotment_status(allotment2)
            expect(response).to eq('ready')
        end

        it 'Checks if the allotment is growing' do
            response = AllotmentHelper.check_allotment_status(allotment3)
            expect(response).to eq('not_ready')
        end
    end
end
