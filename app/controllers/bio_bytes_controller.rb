###############################################
=begin
Purpose - controller for user-editing of BioBytes parts db

#TODO -> Avoid/warn about deleting/changing parts that already exist in some construct


=end
###############################################

class BioBytesController < ApplicationController

  def index

    #get array of all BioBytes in db
    @bytes = BioByte.find(:all)

  end

  def show
    
    #get byte corr. to id
    @byte = BioByte.find(params[:id])

  end
  
  def edit
    @byte = BioByte.find(params[:id])
  end

  def new
    @byte = BioByte.new
  end

  def create
    #linker or ORF?
    @byte=params[:byte][:type].constantize.new(params[:byte])
    @byte.sequence = @byte.sequence.upcase
    #TODO exceptions
    if @byte.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def delete
    BioByte.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def update
  #add code to delete old byte and create new byte if type is changed
    @byte = BioByte.find(params[:id])

    if params[:byte][:type] != @byte.type
      BioByte.find(params[:id]).destroy
      @byte = params[:byte][:type].constantize.new(params[:byte])
    end

    if @byte.update_attributes(params[:byte])
      redirect_to :action => 'show', :id => @byte
    else
      render :action => 'edit'
    end
  end

end
