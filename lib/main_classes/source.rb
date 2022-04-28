class Source
  attr_accessor :name
  attr_reader :id, :items

  def initialize(name, id: Random.rand(1..1000))
    @id = id
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item
    item.source = self
  end

  def remove_item(item)
    @items = @items.reject { |e| e.class.instance_of?(item.class) && e.id == item.id }
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'name' => @name
    }.to_json(*args)
  end
end
