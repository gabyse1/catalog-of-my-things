require_relative 'classes/app'

def display_menu
  puts "\n\nPlease choose an option by entering a number:"
  puts '1 - List books, music albums, movies, or games'
  puts '2 - Add books, music albums, movies, or games'
  puts '3 - List genres, labels, authors, or sources'
  puts '4 - Add genres, labels, authors, or sources'
  puts '5 - Exit'
end

def execute_menu_options(app, option)
  puts "\n"
  case option
  when 1
    app.list_items
  when 2
    app.add_items
  when 3
    app.list_extras
  when 4
    app.add_extras
  end
end

def main
  app = App.new
  option = 0
  while option != 5
    display_menu
    print '[Input the number]: '
    option = gets.chomp.to_i
    execute_menu_options(app, option) if option >= 1 && option <= 4
  end
  app.persist_data
  puts "Thank you for using this app!\n\n"
end

main
