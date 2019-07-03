class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.quality > 0
        (delta, max) = quality_delta(item)
        item.quality = quality_range(item.quality - delta, max) unless delta == 0
      end
      item.sell_in -= 1
    end
  end

  private

  def quality_range(val, max) [0, [max, val].min].max end
  def quality_delta(item)
    default = 1
    default = 2 if item.sell_in <= 0
    max = 50
    [case item.name
    when 'Aged Brie'
      -default
    when 'Sulfuras'
      max = 80
      0
    when 'Backstage passes to a TAFKAL80ETC concert'
      return [item.quality, max] if item.sell_in <= 0 # reset to 0
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
    when 'Golden helmet'
      max = 80
      -default
    else
      default
    end, max]
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
