require_relative './item'

class Book < Item
  attr_accessor :publisher, :cover_state

  def initialize(publisher, cover_state, title, publish_date, id: Random.rand(1..1000), archived: false)
    super(title, publish_date, id: id, archived: archived)
    @publisher = publisher
    @cover_state = cover_state
  end

  def can_be_archived?
    super || @cover_state == 'bad'
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'publisher' => @publisher,
      'cover_state' => @cover_state,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'author' => @author.id,
      'genre' => @genre.id,
      'label' => @label.id,
      'source' => @source.id
    }.to_json(*args)
  end
end
