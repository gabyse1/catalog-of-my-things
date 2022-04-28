require_relative './item'

class Movie < Item
  attr_accessor :silent

  def initialize(silent, title, publish_date, **options)
    super(title, publish_date, **options)
    @silent = silent
  end

  def can_be_archived?
    super || @silent
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'silent' => @silent,
      'title' => @title,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'author' => @author.id,
      'genre' => @genre.id,
      'label' => @label.id,
      'source' => @source.id
    }.to_json(*args)
  end
end
