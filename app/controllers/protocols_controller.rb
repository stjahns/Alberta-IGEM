class ProtocolsController < ApplicationController

  def index 
    @steps = StepGenerator.find(:all, :order => 'subprotocol')
  end

  def edit
    @step = StepGenerator.find(params[:id])
  end

  def delete
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

end
