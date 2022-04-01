class CrowMenu
    def initialize()
        @prompt = TTY::Prompt.new
    end

    def crow_encounter(allotment)
        clear()
        allotment[:time_until_grown] = nil
        allotment[:produce_type] = nil
        TH.slow_text "You finish planting your seeds and head towards your farmhouse."
        TH.slow_text "You hear the sudden sound of a crows caw, you turn to see your crop being ravaged by crows."
        TH.slow_text "You shoo them away, but it was too late. The crop was destroyed."
        puts
        @prompt.keypress('Press any key to continue...')
    end
end
