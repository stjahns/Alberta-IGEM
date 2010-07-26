class StepGeneratorsController < ApplicationController

  before_filter :login_required
  before_filter :can_edit_step_generators?
  def index 
    @steps = StepGenerator.find(:all, :order => 'subprotocol')
  end

  def edit
    @step = StepGenerator.find(params[:id])
  end

  def destroy
    StepGenerator.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def new
    @step = StepGenerator.new
  end

  def create
#TODO validation
    @step = StepGenerator.new(params[:step])
    @step.save
    redirect_to :action => :index
  end

  def update
    @step = StepGenerator.find(params[:id])
    if @step.update_attributes(params[:step])
      redirect_to :action => :index
    else 
      render :action => :edit
    end
  end

  def can_edit_step_generators?
    unless current_user.can_edit_step_generators?
      flash[:notice] = 'ACCESS DENIED, SILLY GOOSE'
      redirect_to home_path 
    end
  end
    
end
