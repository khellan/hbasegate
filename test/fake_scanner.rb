class FakeScanner
  include HBaseGate::ResultScanner
  def initialize(items)
    @items = items
    reset
  end

  def next
    return nil if @index >= @items.length
    @index += 1
    @items[@index]
  end

  def reset
    @index = -1
  end
end
