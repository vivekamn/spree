require File.dirname(__FILE__) + '/../spec_helper'

describe DealHistory do
  before(:each) do
    @deal_history = DealHistory.new
  end

  it "should be valid" do
    @deal_history.should be_valid
  end
end
