class GlossariesController < ApplicationController

  before_filter :set_nav

  # GET /glossaries
  # GET /glossaries.xml
  def index
    @glossaries = Glossary.alphabetise
    @new_gloss = Glossary.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @glossaries }
    end
  end

  # GET /glossaries/1
  # GET /glossaries/1.xml
  def show

    @glossaries = Glossary.alphabetise
    @glossary = Glossary.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @glossary }
      format.xml  { render :xml => @glossaries }
    end
  end

  # GET /glossaries/new
  # GET /glossaries/new.xml
  def new
    @glossary = Glossary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @glossary }
    end
  end

  # GET /glossaries/1/edit
  def edit
    @glossary = Glossary.find(params[:id])
  end

  # POST /glossaries
  # POST /glossaries.xml
  def create
    @glossary = Glossary.new(params[:glossary])

    respond_to do |format|
      if @glossary.save
        flash[:notice] = 'Glossary was successfully created.'
        format.html { redirect_to(glossaries_url) }
        format.xml  { render :xml => @glossary, :status => :created, :location => @glossary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @glossary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /glossaries/1
  # PUT /glossaries/1.xml
  def update
    @glossary = Glossary.find(params[:id])
    respond_to do |format|
      if @glossary.update_attributes(params[:glossary])
        flash[:notice] = 'Glossary was successfully updated.'
        format.html { redirect_to(glossaries_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @glossary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /glossaries/1
  # DELETE /glossaries/1.xml
  def destroy
    @glossary = Glossary.find(params[:id])
    @glossary.destroy

    respond_to do |format|
      format.html { redirect_to(glossaries_url) }
      format.xml  { head :ok }
    end
  end
  private
  def set_nav
	  @navbar_selected = :glossary
  end
end
