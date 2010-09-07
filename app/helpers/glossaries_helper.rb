module GlossariesHelper
  def add_glossary_links(text)
    @glossaries = Glossary.all
    @def = text

    #create a list of terms which must be checked
    @glossaries.each do |entry|
      #check each term to see if it is found in the text

      term = entry.term
      term = term.sub!(/\s*$/){""}
       
      @def_str = @def.to_s

      @regex = Regexp.new(/#{term}\w*/i)
      matchdata = @regex.match(@def_str)
      
      if matchdata
        
        #if the term was found in the text, split the text on that term and insert
        # an html link
        matchdata = matchdata.to_s
        matchdata = matchdata.sub(/\s#{term}\w*/i){"#{term}"}
      

        @def = @def.to_s
        
        @def = @def.sub(/\s#{term}\w*/i){"\s<a class = \"term-link\" href=http://#{SITE_URL}/glossaries/##{term}>#{matchdata}</a>"}
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

      if !@def.blank?
      @def_str = @def.to_s


      @regex = Regexp.new(/<a class = \"term-link\" href=http:\/\/#{SITE_URL}\/glossaries\/##{term}>.*?<\/a>/)
      matchdata = @regex.match(@def_str)
      if matchdata
        matchdata = matchdata.to_s
        matchdata = matchdata.sub(/<a class = \"term-link\" href=http:\/\/#{SITE_URL}\/glossaries\/##{term}>/){""}
        matchdata = matchdata.sub(/<\/a>/){""}
        #if the term was found in the text, split the text on that term and insert
        # an html link
       @def = @def.sub(/<a class = \"term-link\" href=http:\/\/#{SITE_URL}\/glossaries\/##{term}>.*?<\/a>/){"<span class=\"gloss_links\" ><a class = \"term-link\" href=http:\/\/#{SITE_URL}\/glossaries\/##{term}>#{matchdata}<\/a><em class = definition><div><b>#{term}<\/b><\/div>#{definition}<\/em><\/span>"}

      end
      end
      end
    return @def
  end
end

