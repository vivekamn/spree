require File.dirname(__FILE__) + '/../spec_helper'

describe Enquiry do
  before(:each) do
    @enquiry = Enquiry.new
  end

  it "should be valid" do
    @enquiry.should be_valid
  end
end
