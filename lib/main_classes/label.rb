class Label
  attr_accessor :title, :color
  attr_reader :id, :items

  def initialize(title, color, id: Random.rand(1..1000))
    @id = id
    @title = title
    @color = color
    @items = []
  end

  def add_item(item)
    @items << item
    item.label = self
  end

  def remove_item(item)
    @items = @items.reject { |e| e.class.instance_of?(item.class) && e.id == item.id }
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'title' => @title,
      'color' => @color
    }.to_json(*args)
  end
end
