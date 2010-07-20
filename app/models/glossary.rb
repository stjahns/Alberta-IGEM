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
