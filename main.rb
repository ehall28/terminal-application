require 'tty-prompt'
require 'rainbow/refinement'
require 'date'
require 'time'
require 'json'
require './models/farm'
require './views/farm_menu'
require './views/shop_menu'
require './views/crow_menu'
require './helpers/allotment_helper'
require './helpers/terminal_helper'
require './helpers/plant_helper'

include PlantHelper
include AllotmentHelper
include TH # terminal helper - TH is short
using Rainbow

# Checking ARGV (--help, -h)

if ARGV.include?('--help') || ARGV.include?('-h')
    TH.slow_text 'Welcome to Farmy McFarm F.A.C.E'.magenta
    TH.slow_text 'A simple, yet fun, farming simulator text game!'.yellow
    TH.slow_text 'The idea of the game is to plant seeds, harvest them and then sell the produce for gold.'.cyan
    TH.slow_text 'Eventually, you work your way up to buying additional allotments, which allows you to plant'.cyan
    TH.slow_text "more seeds, which gets you more produce AND... you see where I'm going with this...".cyan
    TH.slow_text "But be careful, those crows look like they're up to something! Just make sure you always".red
    TH.slow_text "have gold or seeds handy...".red
    TH.slow_text "If you also get a bit tired on waiting for those cheeky vegetables to grow, perhaps turning on some".green
    TH.slow_text "cheats will get that heart beating, and oh..I ah.. won't tell anyone that you cheated in a farm game..".green
    TH.slow_text 'Just type '.yellow + './run.sh -c '.red + 'or'.yellow + ' ./run.sh --cheats'.red + ' into this here terminal to enable those chea... extra features..'.yellow
    TH.slow_text 'Happy planting :)'.magenta
    return
end

# Start of application
class Main
    def initialize
        @prompt = TTY::Prompt.new
        @choices = [
            { name: "Load saved game", value: 1 },
            { name: "Create new farm", value: 2 },
            { name: "Exit", value: 3 }
        ]
        ascii_art()
        check_update_menu()
        main_menu()
    end

    def ascii_art
        TH.clear()
        # Looks broken because of interpolation/colouring
        begin
            TH.slow_text 'Welcome to...'.cyan
            puts
            TH.slow_text "  #{'Farmy McFarm'.cyan} #{'F.A.C.E'.green}:   #{'_.-^-._'.red}    .--."
            TH.slow_text "                       #{".-'   _   '-.".red} |__|"
            TH.slow_text "   #{'F'.green}#{'armers'.cyan}  #{'A'.green}#{'gainst'.cyan}   #{'/     |_|     \\|  |'.red}"
            TH.slow_text "   #{'C'.green}#{'row'.cyan}  #{'E'.green}#{'spionage'.cyan}   #{'/               \\  |'.red}"
            TH.slow_text "                    #{'/|     _____     |\\ |'.red}"
            TH.slow_text "                     #{'|    |==|==|    |  |'.red}"
            TH.slow_text " #{'|---|---|---|---|---'.blue}#{'|    |--|--|    |  |'.red}"
            TH.slow_text " #{'|---|---|---|---|---'.blue}#{'|    |==|==|    |  |'.red}"
            TH.slow_text "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^".green
            sleep 1.5
            puts
        rescue Interrupt
            TH.clear()
        end
    end

    def check_update_menu
        # Handling load file option - eg incorrect syntax in save_data.json file
        begin
            if File.exist?('save_data.json')
                save_data = JSON.load_file('save_data.json', symbolize_names: true)
                @choices[0][:name] = "Load saved game (#{save_data[:name]})"
            else
                @choices[0][:disabled] = '(No save data found)'
            end
        rescue JSON::ParserError
            puts "Error reading saved game".red
            puts
            @choices[0][:disabled] = '(Corrupt Save!)'.red
        end
    end

    def main_menu
        response = @prompt.select('What would you like to do?', @choices)

        case response
        when 1
            farm = Farm.new
            farm.cheats = true if ARGV.include?('--cheats') || ARGV.include?('-c')
            farm.load_data
            FarmMenu.new(farm)
        when 2
            # go to new menu to create new farm
            farm = Farm.new
            farm.cheats = true if ARGV.include?('--cheats') || ARGV.include?('-c')
            farm.farmers_name = @prompt.ask('What is your name?', default: 'Joe').strip
            puts "Welcome to your new farm, #{farm.farmers_name}!"
            farm.name = @prompt.ask('What would you like to call your farm?', default: 'Farmy McFarm').strip
            puts "#{farm.name} is a fantastic farm name!"
            farm.save_data
            @prompt.keypress('Press any key to begin your new adventure...')
            TH.clear()
            intro()
            FarmMenu.new(farm)
        when 3
            puts "Thank you for playing! See you soon!"
            return
            # exit the application
        end
    end

    def intro()
        puts
        puts
        puts "                                  .-------------------------------."
        puts "                                 | Hey there neighbour! I see      |"
        puts "                  .--.--.        | that you just moved into that   |"
        puts "                .; .;|;. ;.      | ol'farm there. Word of advice,  |"
        puts "              .;_;'     ';_;.    | watch out for those crows.      |"
        puts "              ; ;'       '; ;    | They're up to something,        |"
        puts "             ;; .--.___.--. ;;   | always scheming and stealing    |"
        puts "             ;=[  O )=( O  ]=;   | seeds. But I'm onto them! I'm   |"
        puts "             (  `--' | `--'  )   | a farmer against crow espionage!|"
        puts "             \\|     (      |/    | /------------------------------'                            .--------."
        puts "               .  .:::::.  .     \\/                                                            | cawcaw |"
        puts "                .  '---'  .                                                                    |/-------'"
        puts "                |`.     .'|                                                                    .-.  ,-."
        puts "       ,-------/|  `...'  |\\-------,                                                           ;oo  oo;"
        puts "     ,'       | `.       ,' |        `,                                                       / \\|  |/ \\"
        puts "    /         \\  /'.   ,'\\  /          \\                                                     |. `.  .' .|"
        puts "   ;           |/   \\ /   \\|            ;                                                    `;.;'  `;.;'"
        puts "                                                                                             .-^-.  .-^-."
        @prompt.keypress('Press any key to continue...')
        clear()
        TH.slow_text "Well that was odd, surely these crows are nothing to worry about..."
        @prompt.keypress('Press any key to head to your farm...')
    end
end

# Entry point for application
begin
    Main.new
rescue Interrupt
    TH.clear()
    puts 'Thank you for playing! :)'
end
