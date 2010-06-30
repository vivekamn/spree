require File.dirname(__FILE__) + '/../spec_helper'

describe VerificationCode do
  before(:each) do
    @verification_code = VerificationCode.new
  end

  it "should be valid" do
    @verification_code.should be_valid
  end
end
