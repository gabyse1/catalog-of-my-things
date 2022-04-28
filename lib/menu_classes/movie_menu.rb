require_relative 'app_helpers'
require_relative '../main_classes/movie'
require 'json'

class MovieMenu
  def initialize(author, genre, label, source)
    @author = author
    @genre = genre
    @label = label
    @source = source
    @movies_list = []
    load_movies_from_json
  end

  def add_movie
    puts "\n----- ADDING A NEW MOVIE -----\n"
    print 'Title: '
    title = gets.chomp.strip.to_s
    publish_date = AppHelpers.valid_date_input('Publish date [yyyy/mm/dd]')
    silent = AppHelpers.valid_bool_input?('Silent: [y/n]')
    movie = Movie.new(silent, title, publish_date)
    movie.move_to_archive
    @author.select_author.add_item(movie)
    @genre.select_genre.add_item(movie)
    @label.select_label.add_item(movie)
    @source.select_source.add_item(movie)
    @movies_list << movie
    puts "\nMovie created successfully\n"
  end

  def delete_movie
    list_movies
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @movies_list.length)
    return if option.zero?

    movie = @movies_list[option - 1]
    @author.authors_list.find { |e| e.id == movie.author.id }.remove_item(movie)
    @genre.genres_list.find { |e| e.id == movie.genre.id }.remove_item(movie)
    @label.labels_list.find { |e| e.id == movie.label.id }.remove_item(movie)
    @source.sources_list.find { |e| e.id == movie.source.id }.remove_item(movie)
    @movies_list.delete_at(option - 1)
    puts "\nMovie removed successfully\n"
  end

  def list_movies
    puts "\nNo movie registered yet" if @movies_list.empty?
    puts "\n----- MOVIES -----" unless @movies_list.empty?
    @movies_list.each_with_index.each do |e, i|
      author = "#{e.author.first_name} #{e.author.last_name}"
      genre_label_source = "Genre: #{e.genre.name}, Label: #{e.label.title}, Source: #{e.source.name}"
      puts "#{i + 1}) Title: #{e.title}, Publish date: #{e.publish_date}, Silent: #{e.silent},"
      puts "   Author: #{author}, #{genre_label_source}, ID: #{e.id}"
    end
  end

  def load_movies_from_json
    return unless File.exist?('data/movies.json')

    movies_arr = JSON.parse(File.read('data/movies.json'))
    movies_arr.each do |obj|
      movie = Movie.new(
        obj['silent'],
        obj['title'],
        obj['publish_date'],
        id: obj['id'],
        archived: obj['archived']
      )
      @author.authors_list.find { |e| e.id == obj['author'] }.add_item(movie)
      @genre.genres_list.find { |e| e.id == obj['genre'] }.add_item(movie)
      @label.labels_list.find { |e| e.id == obj['label'] }.add_item(movie)
      @source.sources_list.find { |e| e.id == obj['source'] }.add_item(movie)
      @movies_list << movie
    end
  end

  def store_movies_to_json
    File.write('data/movies.json', JSON.pretty_generate(@movies_list))
  end
end
