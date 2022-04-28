require 'time'

class Item
  attr_reader :id, :title, :publish_date, :genre, :source, :author, :label, :archived

  def initialize(title, publish_date, id: Random.rand(1..1000), archived: false)
    @id = id
    @title = title
    @publish_date = publish_date
    @archived = archived
  end

  def can_be_archived?
    current_year = Time.new.year.to_i
    publish_year = Time.parse(@publish_date).year.to_i
    (current_year - publish_year) > 10
  end

  def move_to_archive
    @archived = can_be_archived?
  end

  def genre=(genre)
    @genre = genre
    genre.items << self unless genre.items.include?(self)
  end

  def label=(label)
    @label = label
    label.items << self unless label.items.include?(self)
  end

  def author=(author)
    @author = author
    author.items << self unless author.items.include?(self)
  end

  def source=(source)
    @source = source
    source.items << self unless source.items.include?(self)
  end
end
