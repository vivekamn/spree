require File.dirname(__FILE__) + '/../spec_helper'

describe Refferer do
  before(:each) do
    @refferer = Refferer.new
  end

  it "should be valid" do
    @refferer.should be_valid
  end
end
