require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  context Address do
    should_validate_presence_of :firstname, :lastname, :address1,
      :city, :zipcode, :country, :phone

    # this validation disabled for now
    # should_not_allow_values_for :phone, "abcd", "1234"

    context "create from factory" do
      setup { Factory :address }
      should_change("Address.count", :by => 1) { Address.count }
    end

    context "for state field validity" do
      setup do
        @address = Factory(:address)
        @test_state = Factory(:state)
      end

      [true,false].each do |state_required| 
        should ("return correct validity when require_state flag is " + state_required.to_s) do
          Spree::Config.set(:address_requires_state => state_required) 
  
          @address.state = @address.state_name = nil
          if state_required
            assert(! @address.valid?, "address with no state info must be invalid")
          else
            assert(  @address.valid?, "address with no state info must be valid")
          end
  
          @address.state = @test_state
          assert_equal(state_required, @address.valid?, "address with state object must be valid")
  
          @address.state = nil
          @address.state_name = "somewhere"
          assert_equal(state_required, @address.valid?, "address with state name must be valid")
  
          # behaviour when two fields are set is tested elsewhere
  
          Spree::Config.set(:address_requires_state => true) 
        end
      end
    end

    context "setting both state fields" do    # testing switchover
      setup do
        @address = Factory(:address)
        @test_state = Factory(:state)
      end

      should "start with state_name field set" do
        assert_not_nil(@address.state_name, "must have a state name at start")

        @address.state = @test_state
        assert(@address.valid?, "overwriting with state should preserve validity")
        assert_nil(@address.state_name, "state_name should be cleared")
        assert_not_nil(@address.state, "state must be present")

        assert(@address.save, "must save with new state")

        @address.state_name = "elsewhere"
        assert(@address.valid?, "overwriting with state_name should preserve validity")
        assert_nil(@address.state, "state should be cleared")
        assert_not_nil(@address.state_name, "state_name must be present")

        assert(@address.save, "must save with new state_name")
      end
    end
  
    context "instance" do
      setup do
        @address = Factory(:address)
      end

      # these two properties now under control of checkout controller
      # should "not be allowed to be changed when have checkout" do
      # should "not be allowed to be changed when have shippment" do
    end

    context "clone" do
      setup do
        @address = Factory(:address)
      end

      should("be valid") { assert @address.clone.valid? }
      ["country", "state"].each do |field|
        should("have same #{field}") {
          assert_equal(@address.clone.send(field), @address.send(field))
        }
      end
    end
  end
end
