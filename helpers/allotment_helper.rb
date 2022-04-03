# module for allotment calculations/checks
module AllotmentHelper
    ALLOTMENT_COST = 300
    # returns the allotment status ie empty
    def check_allotment_status(allotment)
        if allotment[:time_until_grown].nil? # checks if empty
            return 'empty'
        elsif allotment[:time_until_grown] <= Time.now # if crop is grown
            return 'ready'
        else
            return 'not_ready'
        end
    end
end
