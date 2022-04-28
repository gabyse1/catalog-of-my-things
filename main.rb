require_relative 'lib/app'

def app_title
  puts "\n\n"
  puts '***********************************************************'
  puts '*                                                         *'
  puts "*     WELCOME TO THE CATALOG OF MY THINGS CONSOLE APP     *"
  puts '*                                                         *'
  puts '***********************************************************'
end

def main
  app = App.new
  option = 0
  app_title
  while option != 14
    app.main_menu
    print "\n[Enter an option]: "
    option = gets.chomp.to_i
    app.execute_menu_options(option) if option >= 1 && option <= 13
  end
  app.store_data_to_json
  puts "\nThank you for using this app!\n\n"
end

main
