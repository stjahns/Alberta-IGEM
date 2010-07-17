class ExperimentsController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :get_experiment, :except => [:index, :clone, :new, :create]
  before_filter :owns_experiment?, :except => [:index, :show, :clone, :new, :create ]

  # action for displaying print template
  def print
    @steps = @experiment.steps
    
    # renders the print template without the normal layout
    render :layout => false;
  end
      
  # GET /experiments
  # GET /experiments.xml
    def index
    #TODO only the admin experiments here, the users experiments listed on profile
     @experiments = User.find_by_login('admin').experiments;

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.xml
  def show
    @steps = @experiment.steps.all(:order => :step_order)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @experiment }
    end
  end 

  # GET /experiments/new
  # GET /experiments/new.xml
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment }
    end
  end

  # GET /experiments/1/edit
  def edit
   respond_to do |format|
   	format.html
	format.js { render :partial => 'edit', locals =>{ :experiment=>@experiment}}
   end
  end

  # GET /experiments/add_step/1
  def add_step
    @step = Step.create(:experiment_id => @experiment)
    render 'steps/edit'
  end


  # POST /experiments
  # POST /experiments.xml
  def create
    # must pass user_id information since session id is not available 
    # in the model
    @experiment = Experiment.new( params[:experiment] )
    @experiment.user = current_user

    respond_to do |format|
      if @experiment.save
        format.html { 	flash[:notice] = 'Experiment was successfully created.'
			redirect_to(@experiment) }
        format.xml  { render :xml => @experiment, :status => :created, :location => @experiment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def clone 
    old_exp = Experiment.find(params[:id])
    @experiment = old_exp.clone_experiment_for( current_user )

    respond_to do |format|
      format.html { redirect_to(experiments_url) }
      format.xml  { head :ok }
      format.js	  { render :partial =>'description', :locals=>{:experiment=>@experiment} }
    end
  end


  # PUT /experiments/1
  # PUT /experiments/1.xml
  def update
    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
	format.html {	flash[:notice] = 'Experiment was successfully updated.'
 			redirect_to(@experiment) }
	format.xml  { head :ok }
	format.js   { head :ok }
      else
	format.html { render :action => "edit" }
	format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
	
      end
   

   end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.xml
  def destroy
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to(experiments_url) }
      format.xml  { head :ok }
      format.js	  { head :ok }
    end

  end

  private
  def get_experiment
	 @experiment = Experiment.find(params[:id])
  end

  def owns_experiment? 
       is_owner_of( @experiment ) || permission_denied
  end
end
