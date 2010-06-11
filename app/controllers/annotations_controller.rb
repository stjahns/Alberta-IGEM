class AnnotationsController < ApplicationController
#TODO add validations, eg stop>start, no overlapping(?) etc

  def new
    @byte = BioByte.find(params[:id])
    @annotation = Annotation.new
  end

  def create
    @annotation=Annotation.new(params[:annotation])
    @annotation.bio_byte_id = params[:byte_id]
    if @annotation.save
      redirect_to :controller => :bio_bytes,
                  :action => :edit, 
                  :id => params[:byte_id]
    else
      render :action => :new, :id => params[:byte_id]
    end
  end

  def edit
    @annotation = Annotation.find(params[:ann_id])
    @byte = BioByte.find(params[:byte_id])
  end
  
  def update
    @annotation = Annotation.find(params[:ann_id])

    if @annotation.update_attributes(params[:annotation])
      redirect_to :controller => :bio_bytes,
                  :action => :edit,
                  :id => params[:byte_id]
    else
      render :action => :edit, :ann_id =>  @annotation.id, :byte_id => params[:byte_id]
    end
  end
  
  def delete
    Annotation.find(params[:ann_id]).destroy

    redirect_to :controller => :bio_bytes,
                :action => :edit,
                :id => params[:byte_id]
    end
  

end
