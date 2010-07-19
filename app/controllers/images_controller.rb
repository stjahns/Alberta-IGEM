class ImagesController < ApplicationController
  before_filter :login_required, :except => [:thumb, :step, :show]

# need image caching so we don't dynamically generate images every time
# put all the actions that render an image here 
  caches_page :thumb, :step, :show
	

### these actions return different images ##TODO move them to flexi templates 
  # Get /images/1/thumb
  def thumb
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '100x100'}", :type => :flexi
  end
  
  # GET /images/1/step
  def step
    @image = Image.find(params[:id])
    render :inline => "@image.operate {|p| p.resize '300x300'}", :type => :flexi
  end
###################################

# regular actions 
 # GET /images
  # GET /images.xml
  def index
    @images = Image.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.jpg   # show.jpg.flexi 
      format.png  #show.png.flexi
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/new
  # GET /images/new.xml
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.xml
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html {	flash[:notice] = 'Image was successfully created.'
 			redirect_to(@image) }
        format.xml  { render :xml => @image, :status => :created, :location => @image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
   expire_page :action => :thumb, :action => :step ,:action => :show

    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { 	flash[:notice] = 'Image was successfully updated.'
			redirect_to(@image) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(images_url) }
      format.xml  { head :ok }
      format.js	  { head :ok }
    end
  end
end
