require_relative 'app_helpers'
require_relative '../main_classes/music_album'
require 'json'

class MusicAlbumMenu
  def initialize(author, genre, label, source)
    @author = author
    @genre = genre
    @label = label
    @source = source
    @music_albums_list = []
    load_music_albums_from_json
  end

  def add_music_album
    puts "\n----- ADDING A NEW MUSIC ALBUM -----\n"
    print 'Title: '
    title = gets.chomp.strip.to_s
    publish_date = AppHelpers.valid_date_input('Publish date [yyyy/mm/dd]')
    on_spotify = AppHelpers.valid_bool_input?('On spotify: [y/n]')
    music_album = MusicAlbum.new(on_spotify, title, publish_date)
    music_album.move_to_archive
    @author.select_author.add_item(music_album)
    @genre.select_genre.add_item(music_album)
    @label.select_label.add_item(music_album)
    @source.select_source.add_item(music_album)
    @music_albums_list << music_album
    puts "\nMusic Album created successfully\n"
  end

  def delete_music_album
    list_music_albums
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @music_albums_list.length)
    return if option.zero?

    music_album = @music_albums_list[option - 1]
    @author.authors_list.find { |e| e.id == music_album.author.id }.remove_item(music_album)
    @genre.genres_list.find { |e| e.id == music_album.genre.id }.remove_item(music_album)
    @label.labels_list.find { |e| e.id == music_album.label.id }.remove_item(music_album)
    @source.sources_list.find { |e| e.id == music_album.source.id }.remove_item(music_album)
    @music_albums_list.delete_at(option - 1)
    puts "\nMusic album removed successfully\n"
  end

  def list_music_albums
    puts "\nNo music album registered yet" if @music_albums_list.empty?
    puts "\n----- MUSIC ALBUMS -----" unless @music_albums_list.empty?
    @music_albums_list.each_with_index.each do |e, i|
      author = "#{e.author.first_name} #{e.author.last_name}"
      genre_label_source = "Genre: #{e.genre.name}, Label: #{e.label.title}, Source: #{e.source.name}"
      puts "#{i + 1}) Title: #{e.title}, Publish date: #{e.publish_date}, On spotify: #{e.on_spotify},"
      puts "   Author: #{author}, #{genre_label_source}, ID: #{e.id}"
    end
  end

  def load_music_albums_from_json
    return unless File.exist?('data/music_albums.json')

    music_albums_arr = JSON.parse(File.read('data/music_albums.json'))
    music_albums_arr.each do |obj|
      music_album = MusicAlbum.new(
        obj['on_spotify'],
        obj['title'],
        obj['publish_date'],
        id: obj['id'],
        archived: obj['archived']
      )
      @author.authors_list.find { |e| e.id == obj['author'] }.add_item(music_album)
      @genre.genres_list.find { |e| e.id == obj['genre'] }.add_item(music_album)
      @label.labels_list.find { |e| e.id == obj['label'] }.add_item(music_album)
      @source.sources_list.find { |e| e.id == obj['source'] }.add_item(music_album)
      @music_albums_list << music_album
    end
  end

  def store_music_albums_to_json
    File.write('data/music_albums.json', JSON.pretty_generate(@music_albums_list))
  end
end
