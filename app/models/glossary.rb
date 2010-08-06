# == Schema Information
# Schema version: 20100806052151
#
# Table name: glossaries
#
#  id         :integer(4)      not null, primary key
#  term       :string(255)
#  definition :text
#  created_at :datetime
#  updated_at :datetime
#

class Glossary < ActiveRecord::Base

  def self.alphabetise
   @glossaries = Glossary.all
   @original_terms = @glossaries.first.term + @glossaries.first.id.to_s + ","

   @glossaries.each do |entry|
     unless entry.term == @original_terms.first
       @original_terms << entry.term + entry.id.to_s + ","
     end
   end

    @glossaries.sort! { |a,b| a.term.downcase <=> b.term.downcase }

   return @glossaries
  end
end
