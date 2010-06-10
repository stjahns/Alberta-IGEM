class ConstructController < ApplicationController

  before_filter :login_required, :except => :index
  before_filter :is_owner?, :only => [:edit, :delete]

  def index
    @constructs = Construct.find(:all)
  end

  def edit
    #do you have permission?
    @construct = Construct.find(params[:id])
    @order = @construct.part_order

  end

  def delete
    Construct.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def new
    @construct = Construct.new
  end

  def create
    @construct = Construct.new(params[:construct])
    @construct.author = current_user.login
#TODO add validation
    if @construct.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def get_data
    
    orfs = ORF.find(:all)
    linkers = Linker.find(:all)
    annotations = Annotation.find(:all)
    ActiveRecord::Base.include_root_in_json = false
    render :json => { :orfs => orfs, :linkers => linkers, :annotations => annotations}

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

    #gotta return the ids of new parts
    render :json => { :part_ids => partids }

  end

  private

  def is_owner?
    construct = Construct.find(params[:id])
    unless current_user.login == construct.author
      redirect_to :controller => :construct, :action => :index
    end
  end
  
   
end