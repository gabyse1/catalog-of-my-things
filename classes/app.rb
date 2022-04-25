require_relative '../modules/execute_submenu_options'

class App
  def initialize
    @books = load_data_books
    @music_albums = load_data_music_albums
    @movies = load_data_movies
    @games = load_data_games
    @genres = load_data_genres
    @labels = load_data_labels
    @authors = load_data_authors
    @sources = load_data_sources
  end

  include ExecuteSubmenuOptions
end
