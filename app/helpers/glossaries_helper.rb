module GlossariesHelper
  def add_glossary_links(text)
    @glossaries = Glossary.all
    @def = text

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
        @def = @def.sub(/#{term}\w*/){"\s#{id}\s#{matchdata}"}
        #find a way to not match em's when looking for terms in the string
        #@insert_num += 1
      end

    end
    return @def
  end

  def add_popups(linked_text)
    @glossaries = Glossary.all
    @def = linked_text

   
    #create a list of terms which must be checked
    @glossaries.each do |entry|

      #check each term to see if it is found in the text

      id = entry.id
      term = entry.term
      definition = entry.definition
      
      @def_str = @def.to_s

      @regex = Regexp.new(/\s#{id}\s#{term}\w*/)
      matchdata = @regex.match(@def_str)
      if matchdata
        #if the term was found in the text, split the text on that term and insert
        # an html link
        match = matchdata.to_s
        match = match.sub(/\s#{id}\s/){""}

        @def = @def.to_s
        @def = @def.sub(/\s#{id}\s#{term}\w*/){"<a href=http://localhost:3000/glossaries/#{id}>#{match}</a><em class = def>#{definition}</em>"}
        #find a way to not match em's when looking for terms in the string
        #@insert_num += 1
      end

    end
    return @def
  end
end

