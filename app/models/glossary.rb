# == Schema Information
# Schema version: 20100819165030
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

    unless @glossaries.first.blank?
      @original_terms = @glossaries.first.term + @glossaries.first.id.to_s + ","

      @glossaries.each do |entry|
        unless entry.term == @original_terms.first
          @original_terms << entry.term + entry.id.to_s + ","
        end
      end

      @glossaries.sort! { |a,b| a.term.downcase <=> b.term.downcase }
    end

   return @glossaries
  end
  private
   def validate
        errors.add_on_empty %w( term )
        errors.add_on_empty %w( definition )

   end
   validates_format_of :term, :with => /^(\s|[a-zA-Z])+$/, :message =>"must be written with alphabetical letters"
   
end
