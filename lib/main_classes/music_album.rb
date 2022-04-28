require_relative './item'

class MusicAlbum < Item
  attr_accessor :on_spotify

  def initialize(on_spotify, title, publish_date, id: Random.rand(1..1000), archived: false)
    super(title, publish_date, id: id, archived: archived)
    @on_spotify = on_spotify
  end

  def can_be_archived?
    super && @on_spotify
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'on_spotify' => @on_spotify,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'author' => @author.id,
      'genre' => @genre.id,
      'label' => @label.id,
      'source' => @source.id
    }.to_json(*args)
  end
end
