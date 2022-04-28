require_relative 'app_helpers'
require_relative '../main_classes/genre'

class GenreMenu
  attr_reader :genres_list

  def initialize
    @genres_list = []
    load_genres_from_json
  end

  def add_genre
    print 'Genre\'s name: '
    name = gets.chomp.to_s
    @genres_list << Genre.new(name)
    @genres_list[-1]
  end

  def delete_genre
    list_genres
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @genres_list.length)
    return if option.zero?

    if @genres_list[option - 1].items.length.zero?
      @genres_list.delete_at(option - 1)
      puts "\nGenre removed successfully\n"
    else
      puts "\n This genre can't be removed because it is referenced from the next items:\n"
      @genres_list[option - 1].items.each { |e| puts "[#{e.class.name}] ID: #{e.id} PUBLISH DATE: #{e.publish_date}" }
    end
  end

  def list_genres
    puts "\nNo genre registered yet" if @genres_list.empty?
    puts "\n------ AVAILABLE GENRES ------" unless @genres_list.empty?
    @genres_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.name}" }
  end

  def select_genre
    if @genres_list.empty?
      option = 'n'
    else
      puts "\nSelect an genre by number OR create a new one by pressing n key"
      @genres_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.name}" }
      puts 'n) Add a new genre'
      print "\n[Option]: "
      option = gets.chomp.strip.downcase
    end
    option = AppHelpers.select_valid_option(option, 1, @genres_list.length)
    genre = add_genre if option.to_i.zero?
    genre = @genres_list[option.to_i - 1] unless option.to_i.zero?
    genre
  end

  def load_genres_from_json
    return unless File.exist?('data/genres.json')

    genres_arr = JSON.parse(File.read('data/genres.json'))
    genres_arr.each do |obj|
      @genres_list << Genre.new(obj['name'], id: obj['id'])
    end
  end

  def store_genres_to_json
    File.write('data/genres.json', JSON.pretty_generate(@genres_list))
  end
end
