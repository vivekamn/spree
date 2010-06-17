require File.dirname(__FILE__) + '/../spec_helper'

describe EmailTrace do
  before(:each) do
    @email_trace = EmailTrace.new
  end

  it "should be valid" do
    @email_trace.should be_valid
  end
end
