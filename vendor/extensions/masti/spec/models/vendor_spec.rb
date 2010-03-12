require File.dirname(__FILE__) + '/../spec_helper'

describe Vendor do
  before(:each) do
    @vendor = Vendor.new
  end

  it "should be valid" do
    @vendor.should be_valid
  end
end
