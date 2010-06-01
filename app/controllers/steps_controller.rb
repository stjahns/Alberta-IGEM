class StepsController < ApplicationController
  before_filter :get_event

  def get_event
    @experiment = Experiment.find(params[:experiment_id])
  end

  # GET /steps
  # GET /steps.xml
  def index
    #@steps = @experiment.steps.all( :order => "order" )
    #@steps = @experiment.steps.find( :all )
     @steps = @experiment.steps.all( :order => "step_order" )

   
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
	#format.js { render :partial => 'experiment/step', :layout => false and return  } 
        format.html { redirect_to([ @experiment, @step ]) }
	#format.html { render :text => @step.description }
        #format.xml  { head :ok }
	format.xml  { render :xml => @step }
	ActiveRecord::Base.include_root_in_json = false
	format.js { render :json => @step }
      else
       format.html { render :action => "edit" }
      format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
   end
  end

  # called after editing an item
  # PUT /items/1
  # PUT /items/1.xml
#  def update
 #   @item = @experiment.steps.find(params[:id])
  #  dc_ds = params[:item][:dc_ds]
#    #read and write the DC datastream...
 #   @dc_ds = DC_datastream.new(:id => params[:item][:id])
  #  puts 'params update:'
   # pp params

  #  keys = params[:dc_datastream_solr].keys
  #  k = keys.first
    #params[:dc_datastream_solr].each_key do |k|
  #    @dc_ds.send k.to_s+'=',params[:dc_datastream_solr][k]
    #end    

 #   @dc_ds.save_to_fedora

  #  render :text => params[:dc_datastream_solr][k]
#  end

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
