class TruthTableObject
  def initialize
    @checked = {}
    @plan = {}
    @order = []
    @queue = []
  end
  attr_reader :plan, :order

  def next_plan
    @log = {}
    @plan, @order = @queue.shift
    @plan
  end

  def [](index)
    s = "v[#{index}]"
    if @plan.has_key?(s)
      v = @plan[s]
    else
      fplan = @plan.dup
      fplan[s] = false
      fkey = fplan.keys.sort.map {|k| "#{k}=#{fplan[k]}" }.join(' ')
      @order += [s]
      @plan = fplan
      v = false
      if !@checked[fkey]
        tplan = @plan.dup
        tplan[s] = true
        tkey = tplan.keys.sort.map {|k| "#{k}=#{tplan[k]}" }.join(' ')
        torder = @order.dup
        torder[-1] = s
        @queue.unshift [tplan, torder]
        @checked[tkey] = true
        @checked[fkey] = true
      end
    end
    v
  end
end
