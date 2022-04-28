require_relative 'app_helpers'
require_relative '../main_classes/book'
require 'json'

class BookMenu
  def initialize(author, genre, label, source)
    @author = author
    @genre = genre
    @label = label
    @source = source
    @books_list = []
    load_books_from_json
  end

  def add_book
    puts "\n----- ADDING A NEW BOOK -----\n"
    print 'Title: '
    title = gets.chomp.to_s
    publish_date = AppHelpers.valid_date_input('Publish date [yyyy/mm/dd]')
    print 'Publisher: '
    publisher = gets.chomp.to_s
    cover_state = AppHelpers.valid_state_input('Cover state [good,bad]')
    book = Book.new(publisher, cover_state, title, publish_date)
    book.move_to_archive
    @author.select_author.add_item(book)
    @genre.select_genre.add_item(book)
    @label.select_label.add_item(book)
    @source.select_source.add_item(book)
    @books_list << book
    puts "\nBook created successfully\n"
  end

  def delete_book
    list_books
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @books_list.length)
    return if option.zero?

    book = @books_list[option - 1]
    @author.authors_list.find { |e| e.id == book.author.id }.remove_item(book)
    @genre.genres_list.find { |e| e.id == book.genre.id }.remove_item(book)
    @label.labels_list.find { |e| e.id == book.label.id }.remove_item(book)
    @source.sources_list.find { |e| e.id == book.source.id }.remove_item(book)
    @books_list.delete_at(option - 1)
    puts "\nBook removed successfully\n"
  end

  def list_books
    puts "\nNo book registered yet" if @books_list.empty?
    puts "\n----- BOOKS -----" unless @books_list.empty?
    @books_list.each_with_index.each do |e, i|
      author = "#{e.author.first_name} #{e.author.last_name}"
      genre_label_source = "Genre: #{e.genre.name}, Label: #{e.label.title}, Source: #{e.source.name}"
      book_props = "Publisher: #{e.publisher}, Cover state: #{e.cover_state}"
      puts "#{i + 1}) Title: #{e.title}, Publish date: #{e.publish_date}, #{book_props},"
      puts "   Author: #{author}, #{genre_label_source}, ID: #{e.id}"
    end
  end

  def load_books_from_json
    return unless File.exist?('data/books.json')

    games_arr = JSON.parse(File.read('data/books.json'))
    games_arr.each do |obj|
      book = Book.new(
        obj['publisher'],
        obj['cover_state'],
        obj['title'],
        obj['publish_date'],
        id: obj['id'],
        archived: obj['archived']
      )
      @author.authors_list.find { |e| e.id == obj['author'] }.add_item(book)
      @genre.genres_list.find { |e| e.id == obj['genre'] }.add_item(book)
      @label.labels_list.find { |e| e.id == obj['label'] }.add_item(book)
      @source.sources_list.find { |e| e.id == obj['source'] }.add_item(book)
      @books_list << book
    end
  end

  def store_books_to_json
    File.write('data/books.json', JSON.pretty_generate(@books_list))
  end
end
