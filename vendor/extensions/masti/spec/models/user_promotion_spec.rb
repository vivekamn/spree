require File.dirname(__FILE__) + '/../spec_helper'

describe UserPromotion do
  before(:each) do
    @user_promotion = UserPromotion.new
  end

  it "should be valid" do
    @user_promotion.should be_valid
  end
end
