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

def produce_modifier(produce_type)
    case produce_type.downcase
    when 'tomato'
        return rand(1..5)
    when 'corn'
        return rand(3..15)
    when 'carrot'
        return rand(10..20)
    end
end
