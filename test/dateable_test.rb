require 'test_helper'

class DateableTest < ActiveSupport::TestCase
  context "an instance of a Model with a dateable field" do
    setup do
      rebuild_model
      @instance = Dummy.create(date_string: "January 10th, 1946")
    end

    context "with an unset date string" do
      setup do
        @instance = Dummy.create
      end

      should "have a nil date, date_string, and date_specificity" do
        @instance.date.should be_nil
        @instance.date_string.should be_nil
        @instance.date_specificity.should be_nil
      end
    end
  
    context "with an empty date string" do
      setup do
        @instance.date_string = '' 
        @instance.save
      end

      should "have a nil date, date_string, and date_specificity" do
        @instance.date.should be_nil
        @instance.date_string.should be_nil
        @instance.date_specificity.should be_nil
      end
    end

    context "with a string-ey date string" do
      setup do
        @date_string = 'May 18th, 1985'
        @instance.date_string = @date_string
        @instance.save
      end

      should "have a date that matches the string" do
        @instance.date.to_date.should == Date.parse(@date_string)
      end
    end

    context "with a decade of specificity" do
      setup do
        @instance.date_string = "1990s"
        @instance.save
      end

      should "have a specificity_string of 'decade'" do
        @instance.date_specificity_string.should == 'decade'
      end
    end

    context "with an explicitly set date" do
      setup do 
        @date = Time.new 1985, 5, 18
        @instance.date = @date
        @instance.save
      end

      should "have a specificity_string of 'day'" do
        @instance.date_specificity_string.should == 'day'
      end

      should "have a date_string equivalent to the date" do
        @instance.date_string.should == @date.strftime("%B %-d, %Y")
      end
    end
  end
end
