# module is the terminal helper
module TH
    # method used to clear the terminal
    def clear
        system 'clear'
        system 'cls'
    end

    def slow_text(text)
        text.each_char do |c|
            print c
            sleep 0.02
        end
        puts
    end
end
