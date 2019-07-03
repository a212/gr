
class GildedRose
  class Product
    def initialize(item) @item = item end

    def quality_max() 50 end

    def quality_delta
      if @item.sell_in > 0
        1
      else
        2
      end
    end

    def quality_range(val) [0, [quality_max, val].min].max end

    def update_quality
      if @item.quality > 0
        delta = quality_delta
        @item.quality = quality_range(@item.quality - delta) unless delta == 0
      end
      @item.sell_in -= 1
    end
  end

  class AgedBrie < Product
    def quality_delta() -super() end
  end

  class Sulfuras < Product
    def quality_max() 80 end
    def quality_delta() 0 end
  end

  class BackstageTAFKAL80ETC < Product
    def quality_delta
      return @item.quality if @item.sell_in <= 0 # reset to 0
      case @item.sell_in
      when 6..10
        -2
      when 1..5
        -3
      else
        -1
      end
    end
  end

  class Conjured < Product
    def quality_delta() 2 * super end
  end

  class GoldenHelmet < AgedBrie
    def quality_max() 80 end
  end

  def initialize(items)
    @items = items.map {|it| product_wrapper(it) }
  end

  def update_quality
    @items.each(&:update_quality)
  end

  private

  def product_type_name(name)
    ([self.class.to_s, "::"] + name.split(/\s+/).map(&:capitalize)).join
  end

  def product_wrapper(item)
    type = Object.const_get(product_type_name(item.name)) rescue case item.name
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstageTAFKAL80ETC
    else
      Product
    end
    type.new(item)
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
