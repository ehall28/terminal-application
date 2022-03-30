require 'tty-prompt'
require 'rainbow/refinement'
require 'date'
require 'time'
require 'json'
require './src/farm'
require './src/farm_menu'
require './src/shop_menu'
require './helpers/allotment_helper'
require './helpers/terminal_helper'
require './helpers/seed_helper'

include SeedHelper
include AllotmentHelper
using Rainbow

# Checking ARGV (--help, -h)

if ARGV.include?('--help') || ARGV.include?('-h')
end









# Start of application

@prompt = TTY::Prompt.new
clear()

# Looks broken because of interpolation/colouring
puts "#{'Welcome to...'.blue}"
puts "                           #{'+&-'.yellow}"
puts "  #{'Farmy McFarm'.blue} #{'F.A.C.E'.green}:   #{'_.-^-._'.red}    .--."
puts "                       #{".-'   _   '-.".red} |__|"
puts "   #{'F'.green}#{'armers'.blue}  #{'A'.green}#{'gainst'.blue}   #{'/     |_|     \\|  |'.red}"
puts "   #{'C'.green}#{'row'.blue}  #{'E'.green}#{'spionage'.blue}   #{'/               \\  |'.red}"
puts "                    #{'/|     _____     |\\ |'.red}"
puts "                     #{'|    |==|==|    |  |'.red}"
puts " #{'|---|---|---|---|---'.cyan}#{'|    |--|--|    |  |'.red}"
puts " #{'|---|---|---|---|---'.cyan}#{'|    |==|==|    |  |'.red}"
puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^".green
puts
puts "🍅"

choices = [
    { name: "Load saved game", value: 1 }, # , disabled: "(No save data found)"
    { name: "Create new farm", value: 2 },
    { name: "Exit", value: 3 }
]

# Handling load file option - eg incorrect syntax in save_data.json file
begin
    if File.exist?('save_data.json')
        save_data = JSON.load_file('save_data.json', symbolize_names: true)
        choices[0][:name] = "Load saved game (#{save_data[:name]})"
    else
        choices[0][:disabled] = '(No save data found)'
    end
rescue JSON::ParserError
    puts "Error reading saved game".red
    puts
    choices[0][:disabled] = '(Corrupt Save!)'.red
end

begin
    response = @prompt.select('What would you like to do?', choices)

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
        FarmMenu.new(farm)
    when 3
        puts "Thank you for playing! See you soon!"
        return
        # exit the application
    end
rescue Interrupt
    clear()
    puts 'Thank you for playing! :)'
end
