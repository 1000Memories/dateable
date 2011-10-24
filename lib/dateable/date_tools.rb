require 'chronic'

module Dateable
  module DateTools

    DateSpecificityLevel = {
      "day"           => 1,
      "month"         => 2,
      "year"          => 3,
      "several_years" => 4,
      "decade"        => 5,
    }

    ValidDays = (1..31)
    ValidMonths = (1..12)

    def self.date_and_specificity(date_string)
      @current_year = Time.now
      if year_match = (/\s*(\d{4})\s*$/).match(date_string)
        @current_year = Time.parse("July 1 "+year_match[1].to_s)
      end
      unless (/^\s*(\d{4})\s*$/).match(date_string)
        date,specificity = date_with_chronic(date_string)
        return [date, specificity] if date.present? && specificity.present?
      end
      self.parse_year_only(date_string)
    end

    def self.date_with_chronic(date_string)
      date, specificity = nil, nil 
      #when checking if non-year part is parseable, remove trailing /'s and -'s
      if date_range = Chronic.parse(date_string, :guess => false, :now => @current_year)
        date_range_width = date_range.width/86400 #seconds in a day
        date = date_range.first+date_range.width/2
        #month
        if date_range_width <=1
          specificity = self.specificity_int("day")
        #day
        elsif date_range_width <= 31
          specificity = self.specificity_int("month")
        elsif date_range_width <= 365
          specificity = self.specificity_int("year")
        end
      end
      [date, specificity]
    end

    def self.parse_year_only(date_string)
      date,specificity = nil,nil
      if year = (/\d{4}/).match(date_string)
        date = Date.parse("July 1 "+year.to_s)
        specificity = self.specificity_int("year")
        non_year_string = (date_string.gsub(Regexp.new(year.to_s),'')).strip.downcase
        if ["c", "c.","circa", "approx", "around", "about", "~"].include?(non_year_string)
          date = Date.parse("January 1 "+year.to_s)
          specificity = self.specificity_int("several_years")
        elsif ["s", "'s"].include?(non_year_string)
          date = Date.parse("January 1 "+year.to_s)+5*365
          specificity = self.specificity_int("decade")
        # for the case in DMF where day is listed as "00", extract month
        elsif month_match = (/(\d{2})-00/).match(date_string)
          if month_match[1].to_i >= 1 and month_match[1].to_i <= 12
            return self.date_with_chronic("#{month_match[1]}/#{year}")
          end
        end
      end
      if date.present? && date.year == 0
        # special case in DMF where date is "0000-00-00"
        # also, year 0 gets converted to year 2000 in postgres
        return [nil, nil]
      end
      [date, specificity]
    end

    def self.specificity_string(date_specificity_int)
      DateSpecificityLevel.index(date_specificity_int)
    end

    def self.specificity_int(date_specificity_string)
      DateSpecificityLevel[date_specificity_string]
    end
  end
end
