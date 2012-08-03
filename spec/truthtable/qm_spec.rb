require File.join(File.dirname(__FILE__), '..', 'spec_helper')

QM = TruthTable::QM

describe QM do

  describe "test intern_tbl" do
    it "can raise ArgumentError" do
      lambda{ QM.intern_tbl({[0]=>0, []=>1}) }.should raise_error(ArgumentError)
      lambda{ QM.intern_tbl({[:y]=>0}) }.should raise_error(ArgumentError)
      lambda{ QM.intern_tbl({[0]=>:y}) }.should raise_error(ArgumentError)
      lambda{ QM.intern_tbl({[0]=>0, [:x]=>1}) }.should raise_error(ArgumentError)
    end

    it "can return right values" do
      QM.intern_tbl({[0]=>0, [:x]=>0}).should == {[-1]=>0}
      QM.intern_tbl({[0]=>0}).should == {[0]=>0, [1]=>-1}
    end

  end

  describe "test qm" do
    it "can be empty" do
      QM.qm({}).should == []
    end

    it "can pass sample 1" do
      tbl = {
          [0,0,0,0]=>0,
          [0,0,0,1]=>0,
          [0,0,1,0]=>0,
          [0,0,1,1]=>0,
          [0,1,0,0]=>1,
          [0,1,0,1]=>0,
          [0,1,1,0]=>0,
          [0,1,1,1]=>0,
          [1,0,0,0]=>1,
          [1,0,0,1]=>:x,
          [1,0,1,0]=>1,
          [1,0,1,1]=>1,
          [1,1,0,0]=>1,
          [1,1,0,1]=>0,
          [1,1,1,0]=>:x,
          [1,1,1,1]=>1,
      }
      QM.qm(tbl).should == [[true, :x,   true,  :x   ],
                            [true, :x,   :x,    false],
                            [:x,   true, false, false]]

    end

    it "can pass implication" do
      tbl = {
          [false,false]=>true,
          [false,true ]=>true,
          [true, false]=>false,
          [true, true ]=>true,
      }
      QM.qm(tbl).should == [[false, :x], [:x, true]]
    end

    it "can shortcut or" do
      tbl = {
          [0, 0]=>0,
          [1, :x]=>1,
          [0, 1]=>1
      }
      QM.qm(tbl).should == [[true, :x], [:x, true]]
    end

    it "can do 3 ands" do
      tbl = {
          [false,:x,   :x   ]=>false,
          [:x,   false,:x   ]=>false,
          [:x,   :x,   false]=>false,
          [true, true, true ]=>true,
      }
      QM.qm(tbl).should == [[true, true, true]]
    end

    it "can do 3 ors" do
      tbl = {
          [false,false,false]=>false,
          [true, :x,   :x   ]=>true,
          [:x,   true, :x   ]=>true,
          [:x,   :x,   true ]=>true,
      }
      QM.qm(tbl).should == [[true, :x, :x], [:x, true, :x], [:x, :x, true]]
    end

    it "can do majority" do
      tbl = {
          [0,0,0]=>0,
          [0,0,1]=>0,
          [0,1,0]=>0,
          [0,1,1]=>1,
          [1,0,0]=>0,
          [1,0,1]=>1,
          [1,1,0]=>1,
          [1,1,1]=>1,
      }
      QM.qm(tbl).should == [[true, true, :x], [true, :x, true], [:x, true, true]]
    end

    it "can do 4 bit fib predicate" do
      tbl = {
          [0,0,0,0]=>0,
          [0,0,0,1]=>1,     # 1
          [0,0,1,0]=>1,     # 2
          [0,0,1,1]=>1,     # 3
          [0,1,0,0]=>0,
          [0,1,0,1]=>1,     # 5
          [0,1,1,0]=>0,
          [0,1,1,1]=>0,
          [1,0,0,0]=>1,     # 8
          [1,0,0,1]=>0,
          [1,0,1,0]=>0,
          [1,0,1,1]=>0,
          [1,1,0,0]=>0,
          [1,1,0,1]=>1,     # 13
          [1,1,1,0]=>0,
          [1,1,1,1]=>0,
      }
      QM.qm(tbl).should == [[true, false, false, false],
                            [false, false, true, :x],
                            [false, :x, false, true],
                            [:x, true, false, true]]
    end

  end

end

