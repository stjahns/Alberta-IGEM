class ConstructController < ApplicationController

  def index
    @constructs = Construct.find(:all)
  end

  def edit
    @construct = Construct.find(params[:id])
    @order = @construct.part_order
    @part =  Part.new() #for new part to be added

    #get sequence
    @sequence = ""
    @order.each do |part|
      @sequence << BioByte.find(part.bio_byte_id).sequence.upcase
    end

    @pos = @order.map{|p| p.part_order} #get positions of all parts already in there
    if @pos != []
      @pos = @pos.push(@pos[-1]+1)
    else
      @pos = [0]
    end

  end

  def delete
    #TODO destroy assoc. parts too! 
    Construct.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def new
    @construct = Construct.new
    @order = @construct.part_order
  end

  def create
    @construct = Construct.new(params[:construct])
    @construct.part_order #find byte order TODO change method name? 
    if @construct.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

#DEPRECATED!!!
  def add_part
    @construct = Construct.find(params[:id])
    @construct.part_order
    p = Part.new( :bio_byte => BioByte.find(:first), 
                  :construct => @construct )
    @construct.parts << p
    @construct.part_order << p
    @construct.save
    #redirect_to :action => :edit, :id => @construct.id
    render :partial => 'construct', :object => @construct

  end

  def insert_part
    @construct = Construct.find(params[:id]) 
    @part = Part.new(params[:part])

    @order = @construct.part_order

    @construct.part_order.insert(@part.part_order, @part)
    @construct.parts << @part
    @construct.save
    
    redirect_to :action => :edit, :id => @construct.id

  end

  def delete_part

    @construct = Construct.find(params[:id])
    
    @part = Part.find(params[:part_id])
    @part.destroy
    
    @construct.part_order
    @construct.save
    
    redirect_to :action => :edit, :id => @construct.id

  end 

end
