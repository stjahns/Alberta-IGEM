###############################################
=begin
Purpose - controller for user-editing of BioBytes parts db

=end
###############################################

class BioBytesController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :set_nav
  before_filter :can_edit_bio_bytes?, :except => [:index, :show]

  def index

    #get array of all BioBytes in db
    @bytes = BioByte.find(:all)

  end

  def show
    
    #get byte corr. to id
    @byte = BioByte.find(params[:id])
    render :layout => 'datasheet'

  end
  
  def edit
    @image = Image.new
    @byte = BioByte.find(params[:id])
    @backbones = Backbone.all
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
      redirect_to edit_bio_byte_path(@byte)
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

  def upload_abi

    @byte = BioByte.find(params[:id])

    directory = "public/data"

    #TODO validate file type

    #sanitize against like form forgery or whatever crap
    if params[:type] == 'vf'
      type = 'vf'
    elsif params[:type] == 'vr'
      type = 'vr'
    else
      type = 'someoneistryingtohaxorus' #and probably throw some scolding error
    end

    name = "#{type}_#{@byte.id}.abi"
    path = File.join(directory,name)
    File.open(path, "wb") { |f| f.write(params[:upload][:datafile].read)}

    if params[:type] == 'vf'
      @byte.vf_uploaded = true
    elsif params[:type] == 'vr'
      @byte.vr_uploaded = true
    end

    @byte.save

    redirect_to edit_bio_byte_path(@byte)
  
  end

  def validate_sequence
    @byte = BioByte.find(params[:id])

    # TODO check uploaded flags to make sure all data is here ....

    script_path = 'public/perl/val_seq.pl' #store in environments?
    #ref_path = "public/data/#{@byte.name}.fasta" 
    vf_path = "public/data/vf_#{@byte.id}.abi"
    vr_path = "public/data/vr_#{@byte.id}.abi"
    refseq = @byte.backbone.prefix + @byte.sequence + @byte.backbone.suffix
    
    script_out = `#{script_path} #{refseq} #{vf_path} #{vr_path}`
    
    # line 1 -> ref seq
    # line 2 -> char map of highlighting, need to parse with ref sequence
    #           to et properly formatted html with colors

    # model method to parse into html
    @byte.val_string = @byte.parse_validation(script_out)


    @byte.save

    redirect_to bio_byte_path(@byte)
  end

  def download_vf
    @byte = BioByte.find(params[:id])
    send_file "public/data/vf_#{@byte.id}.abi", :filename => "vf_#{@byte.biobyte_id}.abi"
  end

  def download_vr
    @byte = BioByte.find(params[:id])
    send_file "public/data/vr_#{@byte.id}.abi", :filename => "vr_#{@byte.biobyte_id}.abi"
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
  def set_nav
	  @navbar_selected = :parts
  end
  def can_edit_bio_bytes?
    unless current_user.can_edit_bio_bytes?
      redirect_to bio_bytes_path
    end
  end

end
