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
        # elsif 
        end
    end
    choices.push({ name: "Back", value: -1 })
    response = @prompt.select("Allotment menu", choices)

    if response != -1 # user wants to go back
        # logic for individual allotment menu
    end
end
