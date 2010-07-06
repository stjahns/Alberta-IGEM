class AnnotationsController < ApplicationController
#TODO add validations, eg stop>start, no overlapping(?) etc TESTING!!

  def new
    @byte = BioByte.find(params[:bio_byte_id])
    @annotation = @byte.annotations.new
  end

  def create
    @annotation=Annotation.new(params[:annotation])
    @byte=BioByte.find(params[:bio_byte_id])
    @annotation.bio_byte_id = @byte.id
    if @annotation.save
      redirect_to edit_bio_byte_path(@byte)
    else
      render new_bio_byte_annotation_path(@byte, @annotation)
    end
  end

  def edit
    @annotation = Annotation.find(params[:id])
    @byte = BioByte.find(params[:bio_byte_id])
  end
  
  def update
    @annotation = Annotation.find(params[:id])
    @byte = BioByte.find(params[:bio_byte_id])

    if @annotation.update_attributes(params[:annotation])
      redirect_to edit_bio_byte_path(@byte)
    else
      render edit_bio_byte_annotation_path( @byte, @annotation )
    end
  end
  
  def destroy
    @byte=BioByte.find(params[:bio_byte_id])
    #TODO possible optimization here? @byte.annotations.find(...
    Annotation.find(params[:id]).destroy
    redirect_to edit_bio_byte_path(@byte)
  end 

end
