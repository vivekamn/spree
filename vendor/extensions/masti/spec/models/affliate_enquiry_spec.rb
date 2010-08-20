require File.dirname(__FILE__) + '/../spec_helper'

describe AffliateEnquiry do
  before(:each) do
    @affliate_enquiry = AffliateEnquiry.new
  end

  it "should be valid" do
    @affliate_enquiry.should be_valid
  end
end
