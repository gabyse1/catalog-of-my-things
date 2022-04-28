require_relative './item'

class Game < Item
  attr_accessor :multiplayer, :last_played_at

  def initialize(multiplayer, last_played_at, title, publish_date, id: Random.rand(1..1000), archived: false)
    super(title, publish_date, id: id, archived: archived)
    @multiplayer = multiplayer
    @last_played_at = last_played_at
  end

  def can_be_archived?
    current_year =Time.new.year.to_i
    last_played_year = Time.parse(@last_played_at).year.to_i
    super && (current_year - last_played_year) > 2
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'multiplayer' => @multiplayer,
      'last_played_at' => @last_played_at,
      'publish_date' => @publish_date,
      'archived' => @archived,
      'author' => @author.id,
      'genre' => @genre.id,
      'label' => @label.id,
      'source' => @source.id
    }.to_json(*args)
  end
end
