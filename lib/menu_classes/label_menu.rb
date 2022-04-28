require_relative 'app_helpers'
require_relative '../main_classes/label'

class LabelMenu
  attr_reader :labels_list

  def initialize
    @labels_list = []
    load_labels_from_json
  end

  def add_label
    print 'Label\'s title: '
    title = gets.chomp.to_s
    print 'Label\'s color: '
    color = gets.chomp.to_s
    @labels_list << Label.new(title, color)
    @labels_list[-1]
  end

  def delete_label
    list_labels
    puts 'c) Cancel'
    print "\n[Option]: "
    option = gets.chomp.strip.downcase
    option = AppHelpers.select_valid_item_option(option, 1, @labels_list.length)
    return if option.zero?

    if @labels_list[option - 1].items.length.zero?
      @labels_list.delete_at(option - 1)
      puts "\nLabel removed successfully\n"
    else
      puts "\n This label can't be removed because it is referenced from the next items:\n"
      @labels_list[option - 1].items.each { |e| puts "[#{e.class.name}] ID: #{e.id} PUBLISH DATE: #{e.publish_date}" }
    end
  end

  def list_labels
    puts "\nNo label registered yet" if @labels_list.empty?
    puts "\n------ AVAILABLE LABELS ------" unless @labels_list.empty?
    @labels_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.title} #{e.color}" }
  end

  def select_label
    if @labels_list.empty?
      option = 'n'
    else
      puts "\nSelect an label by number OR create a new one by pressing n key"
      @labels_list.each_with_index.each { |e, i| puts "#{i + 1}) #{e.title} #{e.color}" }
      puts 'n) Add a new label'
      print "\n[Option]: "
      option = gets.chomp.strip.downcase
    end
    option = AppHelpers.select_valid_option(option, 1, @labels_list.length)
    label = add_label if option.to_i.zero?
    label = @labels_list[option.to_i - 1] unless option.to_i.zero?
    label
  end

  def load_labels_from_json
    return unless File.exist?('data/labels.json')

    labels_arr = JSON.parse(File.read('data/labels.json'))
    labels_arr.each do |obj|
      @labels_list << Label.new(obj['title'], obj['color'], id: obj['id'])
    end
  end

  def store_labels_to_json
    File.write('data/labels.json', JSON.pretty_generate(@labels_list))
  end
end
