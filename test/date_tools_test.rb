require 'test_helper'

class DateToolsTest < ActiveSupport::TestCase
  include Dateable
  context "the date parser" do
    
    should "be able to parse a year" do
      date,specificity = DateTools.date_and_specificity("1995")
      Date.parse(date.to_s).should == Date.parse("July 1, 1995")
      specificity.should == DateTools::DateSpecificityLevel["year"]
    end

    should "be able to parse a day and a month" do
      date,specificity = DateTools.date_and_specificity("January 25 1995")
      Date.parse(date.to_s).should == Date.parse("January 25, 1995")
      specificity.should == DateTools::DateSpecificityLevel["day"]      
    end
    
    should "be able to parse approximate year" do
      date,specificity = DateTools.date_and_specificity("circa 1995")
      Date.parse(date.to_s).should == Date.parse("July 1, 1995")
    end
    
    should "be able to parse at least the year, if it doesn't understand the month" do
      date,specificity = DateTools.date_and_specificity("Janvier 1985")
      Date.parse(date.to_s).should == Date.parse("July 1, 1985")
    end
    
    should "be able to parse decades" do
      date,specificity = DateTools.date_and_specificity("1950's")
      (Date.parse(date.to_s) - Date.parse("January 1, 1955")).should <= 1
      specificity.should == DateTools::DateSpecificityLevel["decade"]
    end
  end
end

# == Schema Information
#
# Table name: approx_dates
#
#  id               :integer         not null, primary key
#  dateable_id      :integer
#  original_value   :string(255)
#  date             :datetime
#  specificity_level :integer
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

