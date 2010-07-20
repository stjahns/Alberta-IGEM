class ViewerController < ApplicationController
  def show
    @glossary = Glossary.find_by_term(params[:term])
    
    @glossaries = Glossary.all

    @terms = @glossaries.first.term+","

    @glossaries.each do |term|

      if term.term + ","!= @terms
        defname = term.term
        @terms << defname+","
      end
    end

  @def = @glossary.definition

 @def.gsub!(/,/){"@"}

 @terms = @terms.split(/,/)

 @found = "0"
 @termfound = "0"

 @insert_num = 0
 
 @terms.each do |term|


  @def_str = @def.to_s

  @regex = Regexp.new(/#{term}\w*/)
  matchdata = @regex.match(@def_str)
    if matchdata


    matchdata = matchdata.to_s

     @def = @def.to_s
     @def = @def.sub!(/#{term}\w*/){",#{@insert_num}"}

    @insert_num += 1

      if @found == "0"
      @def = @def.split(/,/, 2)
      @found = matchdata
      @termfound = term
      @defar = @def.first+","
      @def.shift
      @def = @def.to_s
      else
        @found << "," +matchdata
        @termfound << "," +term
    end
  end
 end


 @def = @def.split(/,/)
 @def.each do |segment|
   @defar << segment+ ","
end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @glossary}
      format.xml  { render :xml => @terms}

    end
  end

end

