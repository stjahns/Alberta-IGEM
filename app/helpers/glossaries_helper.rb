module GlossariesHelper
  def add_glossary_links(text)
##################################TermListAndTextToBeCheked#####################
    @glossaries = Glossary.all
    @def = text

    if @def =~ /,/ then @def = @def.gsub!(/,/){"@"}end
    #create a list of terms which must be checked
    @glossaries.each do |entry|
    
      #check each term to see if it is found in the text

       id = entry.id
       term = entry.term
       @def_str = @def.to_s

       @regex = Regexp.new(/#{term}\w*/)
       matchdata = @regex.match(@def_str)
       if matchdata
    #if the term was found in the text, split the text on that term and insert
    # an html link
          matchdata = matchdata.to_s

          @def = @def.to_s
          @def = @def.sub!(/#{term}\w*/){"<a href= \"#{id}\">#{matchdata}</a>"}

          #@insert_num += 1
       end

    end
    return @def
  end

end

