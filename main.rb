require 'tty-prompt'
require 'rainbow'
require 'date'
require 'time'
require 'json'
require './src/farm'
require './src/farm_menu'
require './src/shop_menu'
require './helpers/allotment_helpers'
require './helpers/terminal_helpers'
require './helpers/seed_helper'

@prompt = TTY::Prompt.new
clear()

# TODO: add ascii art
puts 'Farmy McFarm F.A.C.E:'
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
    farm = Farm.new('', '') # TODO: change this so it isnt empty strings
    farm.load_data
    FarmMenu.new(farm)
when 2
    # go to new menu to create new farm
    farmers_name = @prompt.ask('What is your name?', default: 'Joe')
    puts "Welcome to your new farm, #{farmers_name}!"
    farm_name = @prompt.ask('What would you like to call your farm?', default: 'Farmy McFarm')
    puts "#{farm_name} is a fantastic name!"
    farm = Farm.new(farm_name, "Farmer #{farmers_name}")
    farm.save_data
    FarmMenu.new(farm)
when 3
    puts "Thank you for playing! See you soon!"
    return
    # exit the application
end
