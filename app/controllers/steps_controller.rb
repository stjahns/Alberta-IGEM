class StepsController < ApplicationController
  before_filter :get_event

  def get_event
    @experiment = Experiment.find(params[:experiment_id])
  end

  # GET /steps
  # GET /steps.xml
  def index
    @steps = @experiment.steps.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = @experiment.steps.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = @experiment.steps.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = @experiment.steps.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    @step = @experiment.steps.new(params[:step])

    respond_to do |format|
      if @step.save
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to([ @experiment, @step ]) }
        format.xml  { render :xml => @step, :status => :created, :location =>[ @experiment, @step ]}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = @experiment.steps.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to([ @experiment, @step ]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = @experiment.steps.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to(experiment_steps_url( @experiment )) }
      format.xml  { head :ok }
    end
  end
end
