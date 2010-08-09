class EncyclopaediasController < ApplicationController
 before_filter :set_nav

  # GET /encyclopaedias
  # GET /encyclopaedias.xml
  def index
    @encyclopaedias = Encyclopaedia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @encyclopaedias }
    end
  end

  # GET /encyclopaedias/1
  # GET /encyclopaedias/1.xml
  def show
    @encyclopaedia = Encyclopaedia.find(params[:id])
    @sections = @encyclopaedia.sections.all(:order => :section_order)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @encyclopaedia, :xml => @sections}
    end
  end

  # GET /encyclopaedias/new
  # GET /encyclopaedias/new.xml
  def new
    @encyclopaedia = Encyclopaedia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @encyclopaedia }
    end
  end

  # GET /encyclopaedias/1/edit
  def edit
    @encyclopaedia = Encyclopaedia.find(params[:id])
  end

  # POST /encyclopaedias
  # POST /encyclopaedias.xml
  def create
    @encyclopaedia = Encyclopaedia.new(params[:encyclopaedia])

    respond_to do |format|
      if @encyclopaedia.save
        flash[:notice] = 'Encyclopaedia was successfully created.'
        format.html { redirect_to(@encyclopaedia) }
        format.xml  { render :xml => @encyclopaedia, :status => :created, :location => @encyclopaedia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @encyclopaedia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /encyclopaedias/1
  # PUT /encyclopaedias/1.xml
  def update
    @encyclopaedia = Encyclopaedia.find(params[:id])

    respond_to do |format|
      if @encyclopaedia.update_attributes(params[:encyclopaedia])
        flash[:notice] = 'Encyclopaedia was successfully updated.'
        format.html { redirect_to(@encyclopaedia) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @encyclopaedia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /encyclopaedias/1
  # DELETE /encyclopaedias/1.xml
  def destroy
    @encyclopaedia = Encyclopaedia.find(params[:id])
    @encyclopaedia.destroy

    respond_to do |format|
      format.html { redirect_to(encyclopaedias_url) }
      format.xml  { head :ok }
    end
  end
  private
  def set_nav
	  @navbar_selected = :articles
  end
end
