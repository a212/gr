class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.quality > 0
        delta = quality_delta(item)
        item.quality = quality_range(item.quality - delta) unless delta == 0
      end
      item.sell_in -= 1
    end
  end

  private

  def quality_range(val) [0, [50, val].min].max end
  def quality_delta(item)
    default = 1
    default = 2 if item.sell_in <= 0
    case item.name
    when 'Aged Brie'
      -default
    when 'Sulfuras'
      0
    when 'Backstage passes to a TAFKAL80ETC concert'
      return item.quality if item.sell_in <= 0 # reset to 0
      case item.sell_in
      when 6..10
        -2
      when 1..5
        -3
      else
        -1
      end
    when 'Conjured'
      2 * default
    else
      default
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
