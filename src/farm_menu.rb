def farm_menu(farm)
    loop do
        system 'clear'
        system 'cls'

        choices = [
            { name: "View allotments", value: 1 }, # , disabled: "()"
            { name: "View inventory", value: 2 },
            { name: "Go to shop", value: 3, disabled: "(Coming soon!)" },
            { name: "Exit", value: 4 }
        ]
        response = @prompt.select("What would you like to do on your farm, #{farm.farmers_name}", choices)

        case response
        when 1
            allotment_menu(farm)
        when 2
            # opens inventory
        when 3
            # Goes to the shop
        when 4 
            # Save and quit
        when 5
            # return to previous menu
        end
    end
end

def allotment_menu(farm)
    choices = []
    farm.allotments.each_with_index do |allotment, index|
        if allotment[:time_until_grown].nil? # allotment is empty
            choices.push({ name: "Allotment #{index + 1} (empty)", value: index })
        elsif allotment[:time_until_grown] <= Time.now # if crop is grown
            choices.push({ name: "Allotment #{index + 1} (#{allotment[:produce_type]})", value: index })
        else # if crop is not grown
            time_diff = allotment[:time_until_grown] - Time.now
            minutes, seconds = time_diff.divmod(60)
            grow_text = "Time until grown (#{minutes}m:#{seconds.to_i}s)"
            choices.push({ name: "Allotment #{index + 1} (#{allotment[:produce_type]}) #{grow_text}", value: index })
        end
    end
    choices.push({ name: "Back", value: -1 })
    response = @prompt.select("Allotment menu", choices)

    if response != -1 # user wants to go back
        # logic for individual allotment menu
    end
end
