require_relative 'app_helpers'
require_relative '../main_classes/game'
require 'json'

class GameMenu
  def initialize(author, genre, label, source)
    @author = author
    @genre = genre
    @label = label
    @source = source
    @games_list = []
    load_games_from_json
  end

  def add_game
    puts "\n----- ADDING A NEW GAME -----\n"
    print 'Title: '
    title = gets.chomp.strip.to_s
    publish_date = AppHelpers.valid_date_input('Publish date [yyyy/mm/dd]')
    multiplayer = AppHelpers.valid_bool_input?('Multiplayer [y/n]')
    last_played_at = AppHelpers.valid_date_input('Last played at [yyyy/mm/dd]')
    game = Game.new(multiplayer, last_played_at, title, publish_date)
    game.move_to_archive
    @author.select_author.add_item(game)
    @genre.select_genre.add_item(game)
    @label.select_label.add_item(game)
    @source.select_source.add_item(game)
    @games_list << game
    puts "\nGame created successfully\n"
  end

  def delete_game
    list_games
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @games_list.length)
    return if option.zero?
    game = @games_list[option - 1]
    @author.authors_list.find { |e| e.id == game.author.id }.remove_item(game)
    @genre.genres_list.find { |e| e.id == game.genre.id }.remove_item(game)
    @label.labels_list.find { |e| e.id == game.label.id }.remove_item(game)
    @source.sources_list.find { |e| e.id == game.source.id }.remove_item(game)
    @games_list.delete_at(option - 1)
    puts "\nGame removed successfully\n"
  end

  def list_games
    puts "\nNo game registered yet" if @games_list.empty?
    puts "\n----- GAMES -----" unless @games_list.empty?
    @games_list.each_with_index.each do |e, i|
      author = "#{e.author.first_name} #{e.author.last_name}"
      genre_label_source = "Genre: #{e.genre.name}, Label: #{e.label.title}, Source: #{e.source.name}"
      game_props = "Multiplayer: #{e.multiplayer}, Last played at: #{e.last_played_at}"
      puts "#{i + 1}) Title: #{e.title}, Publish date: #{e.publish_date}, #{game_props},"
      puts "   Author: #{author}, #{genre_label_source}, ID: #{e.id}"
    end
  end

  def load_games_from_json
    return unless File.exist?('data/games.json')

    games_arr = JSON.parse(File.read('data/games.json'))
    games_arr.each do |obj|
      game = Game.new(
        obj['multiplayer'],
        obj['last_played_at'],
        obj['title'],
        obj['publish_date'],
        id: obj['id'],
        archived: obj['archived']
      )
      @author.authors_list.find { |e| e.id == obj['author'] }.add_item(game)
      @genre.genres_list.find { |e| e.id == obj['genre'] }.add_item(game)
      @label.labels_list.find { |e| e.id == obj['label'] }.add_item(game)
      @source.sources_list.find { |e| e.id == obj['source'] }.add_item(game)
      @games_list << game
    end
  end

  def store_games_to_json
    File.write('data/games.json', JSON.pretty_generate(@games_list))
  end
end
