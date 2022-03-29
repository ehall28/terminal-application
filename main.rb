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
using Rainbow

# Checking ARGV (--help, -h)











# Start of application

@prompt = TTY::Prompt.new
clear()

# TODO: add ascii art
puts 'Farmy McFarm F.A.C.E:'.red
puts 'Farmers Against Crow Espionage'
puts

choices = [
    { name: "Load saved game", value: 1 }, # , disabled: "(No save data found)"
    { name: "Create new farm", value: 2 },
    { name: "Exit", value: 3 }
]

choices[0][:disabled] = '(No save data found)' unless File.exist?('save_data.json')

response = @prompt.select('What would you like to do?', choices)

case response
when 1
    farm = Farm.new
    farm.cheats = true if ARGV.include?('--cheats') || ARGV.include?('-c') # { |arg| arg == '--cheats' || arg == '-c' }
    farm.load_data
    FarmMenu.new(farm)
when 2
    # go to new menu to create new farm
    farm = Farm.new
    farm.farmers_name = @prompt.ask('What is your name?', default: 'Joe')
    puts "Welcome to your new farm, #{farm.farmers_name}!"
    farm.name = @prompt.ask('What would you like to call your farm?', default: 'Farmy McFarm')
    puts "#{farm.name} is a fantastic farm name!"
    farm.save_data
    @prompt.keypress('Press any key to begin your new adventure...')
    FarmMenu.new(farm)
when 3
    puts "Thank you for playing! See you soon!"
    return
    # exit the application
end
