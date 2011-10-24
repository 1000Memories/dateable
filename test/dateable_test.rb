require 'test_helper'



class DateableTest < ActiveSupport::TestCase
  context "an instance of a Model with a dateable field" do
    setup do
      rebuild_model
      @instance = Dummy.new
    end

    context "with an unset date string" do
      should "have a nil date, date_string, and date_specificity" do
        @instance.date.should be_nil
        @instance.date_string.should be_nil
        @instance.date_specificity.should be_nil
      end
    end
  
    context "with an empty date string" do
      setup do
        @instance.date = @date_string
      end
    end

    context "with a string-ey date string" do
      setup do
        @date_string = 'May 18th, 1985'
        @instance.date = @date_string
      end
    end

    context "with a time-ey date" do
      setup do
        @date_obj = Time.new(1981, 3, 20)
        @instance.date = @date_obj
      end
    end

    
  end
end
