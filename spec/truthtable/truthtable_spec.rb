require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Truthtable do
  describe "test tautology" do

    it "can dnf true" do
       TruthTable.new {|v| true }.dnf.to_bool.should be_true
    end

    it "can cnf true" do
      TruthTable.new {|v| true }.cnf.to_bool.should be_true
    end

    it "can formula true" do
      TruthTable.new {|v| true }.formula.to_bool.should be_true
    end

    it "can dnf values" do
      TruthTable.new {|v| v[0] | !v[0] }.dnf.should == "!v[0] | v[0]"
    end

    it "can cnf values" do
      TruthTable.new {|v| v[0] | !v[0] }.cnf.to_bool.should  be_true
    end

    it "can formula values" do
      TruthTable.new {|v| v[0] | !v[0] }.formula.to_bool.should  be_true
    end

  end

  describe "test contradiction" do

    it "can dnf false" do
      TruthTable.new {|v| false }.dnf.to_bool.should be_false
    end

    it "can cnf false" do
      TruthTable.new {|v| false }.cnf.to_bool.should be_false
    end

    it "can formula false" do
      TruthTable.new {|v| false }.formula.to_bool.should be_false
    end

    it "can dnf values" do
      TruthTable.new {|v| v[0] & !v[0] }.dnf.to_bool.should be_false
    end

    it "can cnf values" do
      TruthTable.new {|v| v[0] & !v[0] }.cnf.should == "v[0] & !v[0]"
    end

    it "can formula values" do
      TruthTable.new {|v| v[0] & !v[0] }.formula.to_bool.should  be_false
    end

  end


end
