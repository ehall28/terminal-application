require 'tty-prompt'
require 'rainbow'

prompt = TTY::Prompt.new

def farm_menu(farm)
    prompt.select("What would you like to do on your farm, #{name}")
end
