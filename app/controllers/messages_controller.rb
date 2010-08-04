class MessagesController < ApplicationController
  before_filter :get_group
  before_filter :login_required

  def index
	  @messages = Message.all
  end

  def create
	  @message = @group.messages.new(params[:message])

	  respond_to do |format|
		  if @message.save
			format.js{  render(  :partial=>'groups/message' , :locals=>{ :message => @message, :group=>@group } ) }
			format.html{ redirect_to group_path(@group) }
		  else
			  head :error
		  end
	  end
  end

  def destroy
	  @message = @group.messages.find(params[:id])
	  if @message.destroy
		  head :ok
	  else
		  head :error
	  end
  end

  def update
	@message = @group.messages.find( params[:id] )
	if @group.update_attributes(params[:message])
		render(  :partial=>'group/message' , :locals=>{ :message => @message } )
	else
		head :error
	end

  end

  private
  def get_group
	@group = Group.find(params[:group_id])
  end
end
