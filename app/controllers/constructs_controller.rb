class ConstructsController < ApplicationController
  before_filter :get_exp, :except => [:get_data, :sandbox]
  #before_filter :login_required, :except => :get_data
  #
  skip_before_filter :lock_site, :only => [:get_data, :sandbox]
  
  def get_exp
    @experiment = Experiment.find(params[:experiment_id])
  end

  def index
    @constructs = @experiment.constructs.all
  end

  def new
    @construct = Construct.new
  end

  def create
    @construct = @experiment.constructs.new(params[:construct])
    @construct.author = current_user.login 

    respond_to do |format|
      if @construct.save
        flash[:notice] = 'Construct was successfully created.'
        format.html { redirect_to(edit_experiment_construct_path(@experiment, @construct)) }
        format.xml  { render :xml => @construct, :status => :created, :location =>[ @experiment, @construct ]}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @construct.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @construct = @experiment.constructs.find(params[:id])
    @construct.destroy
    
    #gotta regenerate them steps
    StepGenerator.generate_steps(@experiment)

    respond_to do |format|
      format.html { redirect_to(experiment_path( @experiment )) }
      format.xml  { head :ok }
    end
  end

  def edit
    @construct = @experiment.constructs.find(params[:id])
    @order = @construct.part_order
  end

  def sandbox
    @construct = Construct.new
    @order = @construct.part_order
  end

  def get_data
    
    orfs = ORF.find(:all)
    linkers = Linker.find(:all)
    annotations = Annotation.find(:all)
    backbones = Backbone.find(:all)
    ActiveRecord::Base.include_root_in_json = false
    render :json => { :orfs => orfs, :linkers => linkers, :annotations => annotations, :backbones => backbones}

  end
  
  def save

    partids = params[:part]
    byteids = params[:byte]
    construct = Construct.find(params[:id])
    
    #anything deleted?
    oldparts = Part.find(:all, :conditions => { :construct_id => construct.id } ) 
    oldparts.each do |old|
      exists = false
      partids.each do |new|
        if old.id.to_s == new
          exists = true
        end
      end
      if exists == false
        old.destroy()
      end
    end

    #Who needs a new db entry?
    i=0
    partids.each do |part|
      if part == "new"
        p = Part.new( :bio_byte => BioByte.find(byteids[i]), 
                      :construct => construct )
        p.save
        partids[i] = p.id
        construct.parts << p
      end
      i+=1
    end

    parts = construct.parts
    
    #save the orders
    n=0 
    partids.each do |id|
      p=Part.find(id) 
      p.part_order = n 
      p.save
      n+=1
    end

    #GENERATE protocol steps here!?
    StepGenerator.generate_steps(@experiment)

    #gotta return the ids of new parts
    render :json => { :part_ids => partids }

  end

end
