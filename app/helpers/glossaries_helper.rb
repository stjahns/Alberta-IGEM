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
        matchdata = matchdata.sub(/\s#{term}/){"#{term}"}


        @def = @def.to_s
        
	@def = @def.sub(/\s#{term}\w*/){"\s<a href=http://#{SITE_URL}/glossaries/#{id}>#{matchdata}</a>"}
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

      @regex = Regexp.new(/<a class=\"termLink\" href=http:\/\/localhost:3000\/glossaries\/#{id}>#{term}\w*/)
      matchdata = @regex.match(@def_str)
      if matchdata
        #if the term was found in the text, split the text on that term and insert
        # an html link
        match = matchdata.to_s
        match = match.sub(/<a class=\"termLink\" href=http:\/\/localhost:3000\/glossaries\/#{id}>/){""}
        
        @def = @def.to_s
        @def = @def.sub(/<a href=http:\/\/localhost:3000\/glossaries\/#{id}>#{match}<\/a>/){"<a class=\"gloss\" href=http://localhost:3000/glossaries/#{id}>#{match}</a><em class = def><div><b>#{term}:</b></div>#{definition}</em>"}

        #find a way to not match em's when looking for terms in the string
        #@insert_num += 1
      end

    end
    return @def
  end
end

