require 'dateable/version'
require 'dateable/date_tools.rb'

module Dateable
  # makes setters on #{name}_string
  # set #{name} and #{name}_specificity
  def has_dateable_field(name)
    before_save "set_#{name}_attribs".to_sym, if: "#{name}_string_changed?".to_sym

    define_method "set_#{name}_attribs".to_sym do
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

    define_method "#{name}_specificity_string" do
      specificity_int = self.send "#{name}_specificity"
      specificity_int ? DateTools.specificity_string(specificity_int) : nil
    end
  end
end
