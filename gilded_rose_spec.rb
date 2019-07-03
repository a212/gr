require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    let(:items) do
        GildedRose.new(@items).update_quality
        @items
    end

    it 'does not change the name' do
      @items = [Item.new('foo', 0, 0)]
      expect(items[0].name).to eq 'foo'
    end

    it 'lowers the sell_in' do
      @items = [1, 0, -2].map {|si| Item.new('', si, 0) }
      [0, -1, -3].each_with_index do |si, i|
          expect(items[i].sell_in).to eq si
      end
    end

    it 'reduces Quality to 0 by 1 or 2 (for sell_in >= 0)' do
      @items = [[1, 3], [0, 2], [-2, 10], [-5, -1]].map do |(si, q)|
          Item.new('', si, q)
      end
      [2, 0, 8, -1].each_with_index do |q, i|
        expect(items[i].quality).to eq q
      end
    end

    def new_context_item(sell_in, quality)
        Item.new(self.class.description, sell_in, quality)
    end

    context 'Aged Brie' do
      it 'increases Quality to 50 by 1 or 2' do
        @items = [[0, 2], [1, 49], [-1, 49]].map do |(si, q)|
          new_context_item(si, q)
        end
        [4, 50, 50].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end
    end

    context 'Sulfuras' do
      it 'never changes its Quality' do
        @items = [new_context_item(0, 0)]
        expect(items[0].sell_in).to eq -1
        expect(items[0].quality).to eq 0
      end
    end

    context 'Backstage passes to a TAFKAL80ETC concert' do
      it 'increases Quality to 50 by 1 when sell_in > 10' do
        @items = [[11, 2], [15, 49], [20, 50]].map do |(si, q)|
          new_context_item(si, q)
        end
        [3, 50, 50].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end

      it 'increases Quality to 50 by 2 when sell_in <= 10' do
        @items = [[10, 2], [9, 49], [6, 50]].map do |(si, q)|
          new_context_item(si, q)
        end
        [4, 50, 50].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end

      it 'increases Quality to 50 by 3 when sell_in <= 5' do
        @items = [[5, 2], [4, 48], [3, 50]].map do |(si, q)|
          new_context_item(si, q)
        end
        [5, 50, 50].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end

      it 'drops to 0 after the concert' do
        @items = [[0, 2], [-1, 48], [-3, 50]].map do |(si, q)|
          new_context_item(si, q)
        end
        [0, 0, 0].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end
    end
    context 'Conjured' do
      it 'degrades in Quality twice as fast as normal items' do
        @items = [[5, 10], [0, 20], [-10, 50]].map do |(si, q)|
          new_context_item(si, q)
        end
        [8, 16, 46].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end
    end
    context 'Golden helmet' do
      it 'increase .... ' do
        @items = [[5, 10], [0, 20], [-10, 50], [-1,79], [1, 80]].map do |(si, q)|
          new_context_item(si, q)
        end
        [11, 22, 52, 80, 80].each_with_index do |q, i|
          expect(items[i].quality).to eq q
        end
      end
    end
  end
end
