require "truthtable/version"
require "truthtable/truth_table_object"
require "truthtable/qm"

class TruthTable

  def self.test(&b)
    r = []
    o = TruthTableObject.new
    begin
      result = !!b.call(o)
      inputs = o.plan
      order = o.order
      r << [inputs, result, order]
    end while o.next_plan
    r
  end

  def initialize(&b)
    table = TruthTable.test(&b)
    @table = table
  end

  def to_s
    r = ''
    names = sort_names(all_names.keys)
    format = ''
    sep = ''
    names.each {|name|
      format << "%-#{name.length}s "
      sep << '-' * (name.length+1)
    }
    format << "| %s\n"
    sep << "+--\n"
    r << sprintf(format, *(names + ['']))
    r << sep
    @table.each {|inputs, output, order|
      h = {}
      each_input(inputs) {|name, input|
        h[name] = input
      }
      args = []
      names.each {|name|
        if h.has_key? name
          args << (h[name] ? 't' : 'f').center(name.length)
        else
          args << '?'.center(name.length)
        end
      }
      args << (output ? 't' : 'f')
      r << sprintf(format, *args)
    }
    r
  end

  # :stopdoc:
  def inspect
    result = "#<#{self.class}:"
    @table.each {|inputs, output, order|
      term = []
      each_input(inputs) {|name, input|
        if input
          term << name
        else
          term << "!#{name}"
        end
      }
      result << " #{term.join('&')}=>#{output}"
    }
    result << ">"
    result
  end

  def pretty_print(q)
    q.object_group(self) {
      q.text ':'
      q.breakable
      q.seplist(@table, lambda { q.breakable('; ') }) {|inputs, output, order|
        term = []
        each_input(inputs) {|name, input|
          if input
            term << " #{name}"
          else
            term << "!#{name}"
          end
        }
        q.text "#{term.join('&')}=>#{output}"
      }
    }
  end

  def all_names
    return @all_names if defined? @all_names
    @all_names = {}
    @table.each {|inputs, output, order|
      order.each {|name|
        if !@all_names.has_key?(name)
          @all_names[name] = @all_names.size
        end
      }
    }
    @all_names
  end

  def sort_names(names)
    total_order = all_names
    names.sort_by {|n| total_order[n] }
  end

  def each_input(inputs)
    sort_names(inputs.keys).each {|name|
      yield name, inputs[name]
    }
  end
  # :startdoc:

  # obtains a formula in disjunctive normal form.
  def dnf
    r = []
    @table.each {|inputs, output|
      return output.to_s if inputs.empty?
      next if !output
      term = []
      each_input(inputs) {|name, input|
        if input
          term << name
        else
          term << "!#{name}"
        end
      }
      r << term.join('&')
    }
    return "false" if r.empty?
    r.join(' | ')
  end

  # obtains a formula in conjunctive normal form.
  def cnf
    r = []
    @table.each {|inputs, output|
      return output.to_s if inputs.empty?
      next if output
      term = []
      each_input(inputs) {|name, input|
        if input
          term << "!#{name}"
        else
          term << name
        end
      }
      if term.length == 1
        r << term.join('|')
      else
        r << "(#{term.join('|')})"
      end
    }
    return "true" if r.empty?
    r.join(' & ')
  end

  # obtains a minimal formula using Quine-McCluskey algorithm.
  def formula
    input_names = all_names
    input_names_ary = sort_names(input_names.keys)
    tbl = {}
    @table.each {|inputs, output|
      return output.to_s if inputs.empty?
      inputs2 = [:x] * input_names.length
      inputs.each {|name, input|
        inputs2[input_names[name]] = input ? 1 : 0
      }
      tbl[inputs2] = output ? 1 : 0
    }
    qm = QM.qm(tbl)
    r = []
    qm.each {|term|
      t = []
      num_dontcare = 0
      term.each_with_index {|v, i|
        if v == false
          t << ("!" + input_names_ary[i])
        elsif v == true
          t << input_names_ary[i]
        else # :x
          num_dontcare += 1
        end
      }
      if num_dontcare == term.length
        r << 'true'
      else
        r << t.join('&')
      end
    }
    return "false" if r.empty?
    r.join(' | ')
  end
end
