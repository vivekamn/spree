require File.dirname(__FILE__) + '/../spec_helper'

describe SmsNotify do
  before(:each) do
    @sms_notify = SmsNotify.new
  end

  it "should be valid" do
    @sms_notify.should be_valid
  end
end
