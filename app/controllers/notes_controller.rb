class NotesController < ApplicationController
  before_filter :login_required
  before_filter :get_step
 
  #TODO remove show,new,edit and add image to note 
  def show
    @notes = @step.note
    respond_to do |format|
       format.html
       format.js { render( :partial => 'show', 
			  :locals=>{:step=>@step, :note=>@note})}
    end  
  end

  def new
    @note = Note.new
    respond_to do |format|
      format.html
      format.js { render( :partial => 'new', :locals=>{:step=>@step,:note=>@note})}
    end
  end

  def edit
    @note = @step.note
    respond_to do |format|
      format.html
      format.js { render( :partial => 'edit',:locals=>{:step=>@step,:note=>@note})}
    end
  end

  def create
    @note = Note.new( params[:note] )
    @note.step = @step

    respond_to do |format|
      if @note.save
         format.html {  flash[:notice] = 'note saved'
 			redirect_to experiment_step_path(@experiment,@step) 
	 }
	 format.js { render(:partial=>'note',:locals=>{:step=>@step}  )}
      else
	 format.html {   flash[:notice] = 'there was an error saving your note'
			 redirect_to experiment_step_path(@experiment,@step) 
	 }
	 format.js { render(:partial=>'note',:locals=>{:step=>@step}  )}
      end
    end
  end

  def update
    @note = @step.note
    
    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { 	flash[:notice] = 'Note changed'
			redirect_to :back }
	format.js   { render(:partial => 'show', 
			     :locals=>{:step=>@step, :note=>@note})}
      else
	format.html { 	flash[:notice] = 'There was an error updating your note'
			redirect_to :back }
	format.js   { 	render(:partial => 'show', 
			     :locals=>{:step=>@step, :note=>@note})}
      end
    end
  end
  
  def destroy
    @note = @step.note
    @note.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render(:partial => 'new', :locals=>{:step=>@step, :note=>Note.new })}
    end
  end
  
  ############ actions for adding assests ##################
   # action for uploading images to a note
  require 'fileutils'
  def upload
    @note = @step.note
    
    unless @note.image.blank?
	 @note.image.destroy
    end
     
    @image = Image.new(params[:note])
    @note.image = @image

    respond_to do |format|
      if @image.save 
	format.html {redirect_to([@experiment,@step]) }
	format.js { render(:partial => 'show', 
			   :locals=>{:step=>@step, :note => @note})}
      else
	format.html {	flash[:notice] = 'your photo did not save!'
			redirect_to([@experiment,@step]) }
	format.js   {render(:partial => 'show', 
		:locals=>{:step=>@step, :note => @note} )}
      end
    end
  end
private

  def get_step
    @step = Step.find(params[:step_id])
    @experiment = @step.experiment
  end

end
