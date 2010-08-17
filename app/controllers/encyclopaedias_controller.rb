class EncyclopaediasController < ApplicationController
 before_filter :set_nav
 before_filter :login_required, :except => [:index, :show]

  # GET /encyclopaedias
  # GET /encyclopaedias.xml


# GET /encyclopaedias/1/image_form
  def image_form
    @encyclopaedia = Encyclopaedia.find(params[:id])
    @images = Image.all
  end

  require 'fileutils'
  def upload
    @encyclopaedia = Encyclopaedia.find(params[:id])

    unless @encyclopaedia.image.blank?
      @encyclopaedia.image.destroy
    end

    @image = Image.new(params[:encyclopaedia])
    @encyclopaedia.image = @image

    respond_to do |format|
    
      if @image.save

	#format.html { render(:partial => 'step', :locals=>{ :step => @step} )  }
	format.xml { render(:partial => 'encyclopaedia', :locals=>{ :encyclopaedia => @encyclopaedia} )  }
	format.js { render(:partial => 'encyclopaedia', :locals=>{ :encyclopaedia => @encyclopaedia} )  }
	format.html {redirect_to(edit_encyclopaedia_path(@encyclopaedia)) }
      else

	flash[:notice] = "your photo did not save!"
	format.html {redirect_to(@encyclopaedia) }
	format.js   {render(:partial => 'encyclopaedia', :locals=>{:encyclopaedia=>@encyclopaedia})}
      end
    end

  end

  def index
    @encyclopaedias = Encyclopaedia.all
    @new_article = Encyclopaedia.new

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
      format.xml  { render :xml => @encyclopaedia}
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