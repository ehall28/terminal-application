require 'tty-prompt'
require 'rainbow'
require './farm'
require './farm_menu'

prompt = TTY::Prompt.new

system 'clear'
system 'cls'
# TODO: add ascii art
puts 'Farmy McFarm F.A.C.E:'
puts 'Farmers Against Crow Espionage'
puts

choices = [
    { name: "Load saved game", value: 1 }, # , disabled: "(No save data found)"
    { name: "Create new farm", value: 2 },
    { name: "Exit", value: 3 }
]

choices[0][:disabled] = '(No save data found)' unless File.exist?('saves.rb')

response = prompt.select('What would you like to do?', choices)

case response
when 1
    # loads saved game data
when 2
    # go to new menu to create new farm
    farmers_name = prompt.ask('What is your name?', default: 'Joe')
    puts "Welcome to your new farm, #{farmers_name}!"
    farm_name = prompt.ask('What would you like to call your farm?', default: 'Farmy McFarm')
    puts "#{farm_name} is a fantastic name!"
    farm = Farm.new(farm_name, "Farmer #{farmers_name}")
when 3
    # exit the application
end
