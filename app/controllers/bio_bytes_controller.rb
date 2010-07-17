###############################################
=begin
Purpose - controller for user-editing of BioBytes parts db

=end
###############################################

class BioBytesController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :is_admin?, :except => [:index, :show]
  layout 'experiments'


  def index

    #get array of all BioBytes in db
    @bytes = BioByte.find(:all)

  end

  def show
    
    #get byte corr. to id
    @byte = BioByte.find(params[:id])

  end
  
  def edit
    @image = Image.new
    @byte = BioByte.find(params[:id])
  end

  def new
    @byte = BioByte.new
  end

  def create
    #linker or ORF?
    @byte=params[:byte][:type].constantize.new(params[:byte])
    @byte.sequence = @byte.sequence.upcase
    #TODO exceptions
    if @byte.save
      redirect_to bio_bytes_path
    else
      render new_bio_byte_path
    end
  end

  def destroy
    #TODO test this
    unless Part.find(:first, :conditions => {:bio_byte_id => params[:id]})
      BioByte.find(params[:id]).destroy
    else
      #flash error - part exists in some construct
    end

    redirect_to bio_bytes_path
  end

  def update
  #add code to delete old byte and create new byte if type is changed
    @byte = BioByte.find(params[:id])

    if params[:byte][:type].constantize != @byte.class
      BioByte.find(params[:id]).destroy
      @byte = params[:byte][:type].constantize.new(params[:byte])
    end

    if @byte.update_attributes(params[:byte])
      redirect_to bio_byte_path(@byte)
    else
      render edit_bio_byte_path(@byte)
    end
  end

  def upload
    @byte = BioByte.find(params[:id])

    unless @byte.image.blank?
      @byte.image.destroy
    end
    @image = Image.new(params[:image])
    @image.save
    @byte.image_id = @image.id
    @byte.save

    redirect_to edit_bio_byte_path(@byte)

  end

  def upload_desc_img

    @byte = BioByte.find(params[:id])

    unless @byte.bio_byte_image.blank?
      unless @byte.bio_byte_image.image.blank?
        @byte.bio_byte_image.image.destroy
      end
      @byte.bio_byte_image.destroy
    end

    @image = Image.new(params[:image])
    @image.save
    @byte.reload
    @byte.create_bio_byte_image
    @byte.bio_byte_image.image_id = @image.id
    @byte.bio_byte_image.save
    @byte.save

    redirect_to edit_bio_byte_path(@byte)

  end

  private

  def is_admin
    unless current_user.login == "admin"
      redirect_to bio_bytes_path
    end
  end

end
