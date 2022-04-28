require_relative 'app_helpers'
require_relative '../main_classes/author'

class AuthorMenu
  attr_reader :authors_list

  def initialize
    @authors_list = []
    load_authors_from_json
  end

  def add_author
    print 'Author\'s first name: '
    first_name = gets.chomp.to_s
    print 'Author\'s last name: '
    last_name = gets.chomp.to_s
    @authors_list << Author.new(first_name, last_name)
    @authors_list[-1]
  end

  def delete_author
    list_authors
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @authors_list.length)
    return if option.zero?
    if @authors_list[option - 1].items.length.zero?
      @authors_list.delete_at(option - 1)
      puts "\nAuthor removed successfully\n"
    else
      puts "\n This author can't be removed because it is referenced from the next items:\n"
      @authors_list[option - 1].items.each { |e| puts "[#{e.class.name}] ID: #{e.id} PUBLISH DATE: #{e.publish_date}" }
    end
  end

  def list_authors
    puts "\nNo author registered yet" if @authors_list.empty?
    puts "\n------ AVAILABLE AUTHORS ------" unless @authors_list.empty?
    @authors_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.first_name} #{e.last_name}" }
  end

  def select_author
    if @authors_list.empty?
      option = 'n'
    else
      puts "\nSelect an author by number OR create a new one by pressing n key"
      @authors_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.first_name} #{e.last_name}" }
      puts 'n) Add a new author'
      print "\n[Option]: "
      option = gets.chomp.strip.downcase
    end
    option = AppHelpers.select_valid_option(option, 1, @authors_list.length)
    author = add_author if option.to_i.zero?
    author = @authors_list[option.to_i - 1] unless option.to_i.zero?
    author
  end

  def load_authors_from_json
    return unless File.exist?('data/authors.json')

    authors_arr = JSON.parse(File.read('data/authors.json'))
    authors_arr.each do |obj|
      @authors_list << Author.new(obj['first_name'], obj['last_name'], id: obj['id'])
    end
  end

  def store_authors_to_json
    File.write('data/authors.json', JSON.pretty_generate(@authors_list))
  end
end