module ExecuteSubmenuOptions
  def menu_items
    option = 0
    while option < 1 || option > 4
      puts '1 - List all books'
      puts '2 - List all music albums'
      puts '3 - List all movies'
      puts '4 - List all games'
      option = gets.chomp.to_i
    end
    option
  end

  def menu_extras
    option = 0
    while option < 1 || option > 4
      puts '1 - List all genres'
      puts '2 - List all labels'
      puts '3 - List all authors'
      puts '4 - List all sources'
      option = gets.chomp.to_i
    end
    option
  end

  def add_items
    option = menu_items
    case option
    when 1
      add_book
    when 2
      add_music_album
    when 3
      add_movie
    when 4
      add_game
    end
  end

  def add_extras
    option = menu_extras
    case option
    when 1
      add_genre
    when 2
      add_label
    when 3
      add_author
    when 4
      add_source
    end
  end
end
