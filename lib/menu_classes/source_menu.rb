require_relative 'app_helpers'
require_relative '../main_classes/source'

class SourceMenu
  attr_reader :sources_list

  def initialize
    @sources_list = []
    load_sources_from_json
  end

  def add_source
    print 'Source\'s name: '
    name = gets.chomp.to_s
    @sources_list << Source.new(name)
    @sources_list[-1]
  end

  def delete_source
    list_sources
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @sources_list.length)
    return if option.zero?

    if @sources_list[option - 1].items.length.zero?
      @sources_list.delete_at(option - 1)
      puts "\nSource removed successfully\n"
    else
      puts "\n This source can't be removed because it is referenced from the next items:\n"
      @sources_list[option - 1].items.each { |e| puts "[#{e.class.name}] ID: #{e.id} PUBLISH DATE: #{e.publish_date}" }
    end
  end

  def list_sources
    puts "\nNo source registered yet" if @sources_list.empty?
    puts "\n------ AVAILABLE SOURCES ------" unless @sources_list.empty?
    @sources_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.name}" }
  end

  def select_source
    if @sources_list.empty?
      option = 'n'
    else
      puts "\nSelect an source by number OR create a new one by pressing n key"
      @sources_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.name}" }
      puts 'n) Add a new source'
      print "\n[Option]: "
      option = gets.chomp.strip.downcase
    end
    option = AppHelpers.select_valid_option(option, 1, @sources_list.length)
    source = add_source if option.to_i.zero?
    source = @sources_list[option.to_i - 1] unless option.to_i.zero?
    source
  end

  def load_sources_from_json
    return unless File.exist?('data/sources.json')

    sources_arr = JSON.parse(File.read('data/sources.json'))
    sources_arr.each do |obj|
      @sources_list << Source.new(obj['name'], id: obj['id'])
    end
  end

  def store_sources_to_json
    File.write('data/sources.json', JSON.pretty_generate(@sources_list))
  end
end
