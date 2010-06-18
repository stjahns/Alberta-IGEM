class NotesController < ApplicationController
  before_filter :login_required
  before_filter :get_step
 
  #TODO remove show,new,edit and add image to note 
  def show
    @notes = @step.note_for( current_user )
  end  
  
  def new
    @note = @step.notes.new
  end

  def edit
    @note = @step.notes.find(params[:id])
  end

  def create
    @note = @step.notes.new( params[:note] )
    @note.user = current_user

    respond_to do |format|
      if @note.save
         flash[:notice] = 'note saved'
	 format.html { redirect_to experiment_step_path(@experiment,@step) }
      else
	 flash[:notice] = 'there was an error saving your note'
	 format.html { redirect_to experiment_step_path(@experiment,@step) }
      end
    end
  end

  def update
    @note = @step.notes.find(params[:id])
    
    respond_to do |format|
      if @note.update_attributes(params[:note])
        flash[:notice] = 'Note changed'
	format.html { redirect_to :back }
      else
	flash[:notice] = 'There was an error updating your note'
        format.html { redirect_to :back }
      end
    end

  end
  
  def destroy
    @note = @step.notes.find(params[:id])
    @note.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
    end

  end
  private

  def get_step
    @step = Step.find(params[:step_id])
    @experiment = @step.experiment
  end

#  def permission_denied
#    flash[:notice] = 'You may only add notes to your own, or the default experiments'
#    redirect_to :back
#  end
  
end
