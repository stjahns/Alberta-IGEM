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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @glossary}
      format.xml  { render :xml => @terms}

    end
  end

end

