require_relative './menu_classes/app_helpers'
require_relative './menu_classes/author_menu'
require_relative './menu_classes/genre_menu'
require_relative './menu_classes/label_menu'
require_relative './menu_classes/source_menu'
require_relative './menu_classes/game_menu'
require_relative './menu_classes/book_menu'
require_relative './menu_classes/movie_menu'
require_relative './menu_classes/music_album_menu'

class App
  def initialize
    @author_menu = AuthorMenu.new
    @genre_menu = GenreMenu.new
    @label_menu = LabelMenu.new
    @source_menu = SourceMenu.new
    @game_menu = GameMenu.new(@author_menu, @genre_menu, @label_menu, @source_menu)
    @book_menu = BookMenu.new(@author_menu, @genre_menu, @label_menu, @source_menu)
    @movie_menu = MovieMenu.new(@author_menu, @genre_menu, @label_menu, @source_menu)
    @music_album_menu = MusicAlbumMenu.new(@author_menu, @genre_menu, @label_menu, @source_menu)
  end

  def main_menu
    puts "\n\nExecute tasks by selecting an option from the following menu:"
    puts '-------------------------------------------------------------'
    puts '1.-  List Books'
    puts '2.-  List Games'
    puts '3.-  List Movies'
    puts '4.-  List Music Albums'
    puts '5.-  List Authors'
    puts '6.-  List Labels'
    puts '7.-  List Genres'
    puts '8.-  List Sources'
    puts '9.-  Add a Book'
    puts '10.- Add a Game'
    puts '11.- Add a Movie'
    puts '12.- Add a Music Album'
    puts '13.- Delete Options'
    puts '14.- Exit'
  end

  def delete_menu
    puts "\nDelete an item by selecting one:"
    puts '--------------------------------'
    puts '1.- Delete a Book'
    puts '2.- Delete a Game'
    puts '3.- Delete a Movie'
    puts '4.- Delete a Music Album'
    puts '5.- Delete an Author'
    puts '6.- Delete a Genre'
    puts '7.- Delete a Label'
    puts '8.- Delete a Source'
    puts 'c.- Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, 8)
    return if option.zero?

    delete_options(option)
  end

  def execute_menu_options(option)
    case option
    when 1, 2, 3, 4 then list_item_options(option)
    when 5, 6, 7, 8 then list_extra_options(option)
    when 9, 10, 11, 12 then add_options(option)
    when 13 then delete_menu
    end
  end

  def list_item_options(option)
    case option
    when 1 then @book_menu.list_books
    when 2 then @game_menu.list_games
    when 3 then @movie_menu.list_movies
    when 4 then @music_album_menu.list_music_albums
    end
  end

  def list_extra_options(option)
    case option
    when 5 then @author_menu.list_authors
    when 6 then @genre_menu.list_genres
    when 7 then @label_menu.list_labels
    when 8 then @source_menu.list_sources
    end
  end

  def add_options(option)
    case option
    when 9 then @book_menu.add_book
    when 10 then @game_menu.add_game
    when 11 then @movie_menu.add_movie
    when 12 then @music_album_menu.add_music_album
    end
  end

  def delete_options(option)
    case option
    when 1, 2, 3, 4 then delete_item_options(option)
    when 5, 6, 7, 8 then delete_extra_options(option)
    end
  end

  def delete_item_options(option)
    case option
    when 1 then @book_menu.delete_book
    when 2 then @game_menu.delete_game
    when 3 then @movie_menu.delete_movie
    when 4 then @music_album_menu.delete_music_album
    end
  end

  def delete_extra_options(option)
    case option
    when 5 then @author_menu.delete_author
    when 6 then @genre_menu.delete_genre
    when 7 then @label_menu.delete_label
    when 8 then @source_menu.delete_source
    end
  end

  def store_data_to_json
    @author_menu.store_authors_to_json
    @genre_menu.store_genres_to_json
    @label_menu.store_labels_to_json
    @source_menu.store_sources_to_json
    @book_menu.store_books_to_json
    @game_menu.store_games_to_json
    @movie_menu.store_movies_to_json
    @music_album_menu.store_music_albums_to_json
  end
end
