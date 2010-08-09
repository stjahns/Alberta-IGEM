class SectionsController < ApplicationController
  # GET /sections
  # GET /sections.xml

  before_filter :get_encyclopaedia
  #before_filter :login_required


  def get_encyclopaedia
    @encyclopaedia = Encyclopaedia.find(params[:encyclopaedia_id])
    #puts "encyclopaedia id is #{@section.encyclopaedia_id}"
  end


  def index
    @sections = @encyclopaedia.sections.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sections }
    end
  end

  # GET /sections/1
  # GET /sections/1.xml
  def show
    @section = @encyclopaedia.sections.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /sections/new
  # GET /sections/new.xml
  def new
    @section = @encyclopaedia.sections.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /sections/1/edit
  def edit
    @section = @encyclopaedia.sections.find(params[:id])
    
  end

  # POST /sections
  # POST /sections.xml
  def create
    @section = @encyclopaedia.sections.new(params[:section])

    respond_to do |format|
      if @section.save
        flash[:notice] = 'Section was successfully created.'
        format.html { redirect_to(@encyclopaedia, @section) }
        format.xml  { render :xml => @section, :status => :created, :location => @section }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.xml
  def update
    @section = @encyclopaedia.sections.find(params[:id])

    respond_to do |format|
      if @section.update_attributes(params[:section])
        flash[:notice] = 'Section was successfully updated.'
        format.html { redirect_to(@encyclopaedia,@section) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.xml
  def destroy
    @section = @encyclopaedia.sections.find(params[:id])
    @section.destroy

    respond_to do |format|
      puts "redirecting..."
      format.html { redirect_to(encyclopaedia_sections_url(@encyclopaedia)) }
      format.xml  { head :ok }
    end
  end


 require 'fileutils'
  def upload
    @section = @encyclopaedia.sections.find(params[:id])

    unless @section.image.blank?
      @section.image.destroy
    end
   
    @image = Image.new(params[:section])
    @image.caption = params[:caption]
    @section.caption = params[:caption]
    @section.image = @image
    
    respond_to do |format|

      if @image.save

	#format.html { render(:partial => 'step', :locals=>{ :step => @step} )  }
	format.xml { render(:partial => 'section', :locals=>{ :section => @section} )  }
	format.js { render(:partial => 'section', :locals=>{ :section => @section} )  }
	format.html {redirect_to(edit_encyclopaedia_section_path(@encyclopaedia, @section)) }
      else
 
	flash[:notice] = 'your photo did not save!'
	format.html {redirect_to([@encyclopaedia,@section]) }
	format.js   {render(:partial => 'section', :locals=>{:section=>@section})}
      end
    end
  end
end