require 'dateable/version'
require 'dateable/date_tools.rb'

module Dateable
  
  module ClassMethods
    # makes setters on #{name}_string
    # set #{name} and #{name}_specificity
    def has_dateable_field(name)
      include InstanceMethods
      
      before_save :set_date_attribs, if: "#{name}_string_changed?".to_sym

      define_method :set_date_attribs do
        date_string = self.send("#{name}_string")
        
        if date_string.blank?
          #if it's blank, nilify everything
          date_string, date, specificity = nil, nil, nil
        else
          date, specificity = DateTools.date_and_specificity(date_string)
        end

        self.send("#{name}=", date)
        self.send("#{name}_specificity=", specificity)
        self.send("#{name}_string=", date_string)

        [date, specificity]
      end
    end
  end

end
