class Item
  attr_accessor :id, :publish_date, :genre, :source, :author, :label, :archived

  def initialize(publish_date, id: Random.rand(1..1000), archived: false)
    @id = id
    @publish_date = publish_date
    @archived = archived
    @genre = nil
    @source = nil
    @author = nil
    @label = nil
  end

  def can_be_archive?
    @publish_date > 10
  end

  def move_to_archive
    @archived = can_be_archive?
  end
end
