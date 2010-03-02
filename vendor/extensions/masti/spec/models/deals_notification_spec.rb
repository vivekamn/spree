require File.dirname(__FILE__) + '/../spec_helper'

describe DealsNotification do
  before(:each) do
    @deals_notification = DealsNotification.new
  end

  it "should be valid" do
    @deals_notification.should be_valid
  end
end
