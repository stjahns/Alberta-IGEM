class StepsController < ApplicationController
  before_filter :get_experiment
  before_filter :login_required
  before_filter :owns_experiment? 


  def get_experiment
    @experiment = Experiment.find(params[:experiment_id])   
  end

  # GET /steps
  # GET /steps.xml
  def index
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
      format.js   { render( :partial => 'step_new', :locals =>{:step=>@step}) }
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
    @step.autogenerated=false

    respond_to do |format|
      if @step.save
        format.html { 	flash[:notice] = 'Step was successfully created.'
			redirect_to([ @experiment, @step ]) }
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
        format.html { 	flash[:notice] = 'Step was successfully updated.'
			redirect_to([ @experiment, @step ]) }
        #format.xml  { head :ok }
	format.xml  { render :xml => @step }
	format.js { render(:partial => 'step', :locals=>{ :step => @step} )  }
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
      format.js	  { head :ok }
    end
  end 
 
  ############ actions for adding assests ##################
   # action for uploading images to a step
  require 'fileutils'
  def upload
    @step = @experiment.steps.find(params[:id])
    
    unless @step.image.blank?
	 @step.image.destroy
    end
    @image = Image.new(params[:step])
    @step.image = @image
    
    respond_to do |format|
    
      if @image.save 
	
	#format.html { render(:partial => 'step', :locals=>{ :step => @step} )  }
	format.xml { render(:partial => 'step', :locals=>{ :step => @step} )  }
	format.js { render(:partial => 'step', :locals=>{ :step => @step} )  }
	format.html {redirect_to([@experiment,@step]) }
      else
	format.html {	flash[:notice] = 'your photo did not save!'
 			redirect_to([@experiment,@step]) }
	format.js   {render(:partial => 'step', :locals=>{:step=>@step})}
      end
    end
  end


  ###### actions for repositioning  ####################
  
  def up
    #move up the list	  
    @step = @experiment.steps.find(params[:id])
    
    respond_to do |format|
         if @step.move_up 
	     flash[:notice] = 'Order updated'
	     format.html { redirect_to experiment_steps_path(@experiment) }
         else
	     flash[:notice] = 'The step could not be reordered'
             format.html { redirect_to experiment_steps_path(@experiment) }

         end
       end  
  end

  def down
    # move step down the list	  
    @step = @experiment.steps.find(params[:id])
    
   respond_to do |format|
      if @step.move_down
         flash[:notice] = 'Order updated'
         format.html { redirect_to experiment_steps_path(@experiment) }
      else
         flash[:notice] = 'The step could not be reordered'
         format.html { redirect_to experiment_steps_path(@experiment) }
       end
    end 
  end

 
  def insert_before
    insert_step 'before'    
  end
  def insert_after
    insert_step 'after'
  end

  private
  def owns_experiment?
	is_owner_of(@experiment) || permission_denied 
  end

  
  def insert_step(location)
      pivot = @experiment.steps.find(params[:id])
      @step = pivot.insert_new(location)
     respond_to do |format| 
	     if @step
	       message = 'step inserted'
	     else
	       messge = 'step not inseted'
	     end 
	     format.html {  redirect_to experiment_steps_path(@experiment)    }
	     format.js   { render( :partial=>'experiments/step', 
		:locals=>{:step=>@step,:experiment=>@experiment} )}
     end 
  end

end
