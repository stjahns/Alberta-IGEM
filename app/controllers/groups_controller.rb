class GroupsController < ApplicationController
  def index
	@groups = Group.all
  end

  def show
	@group = get_group_by_id_or_name
	@members = @group.users
  end

  def new
	  @group = Group.new
  end

  def destroy
	  @group = Group.find(params[:id])
	  @group.destroy

	  redirect_to( groups_path )
  end

  def create
	  @group = Group.new( params[:group] )
	  if  @group.save
	  
		  # assign creater to admin_role of group
		  current_user.group = @group
		  current_user.role = @group.admin_role
		  
		  if current_user.save
			flash[:notice] = 'The group was succesfully created.'
			#redirect_to pretty_group_path( @group.name )
			redirect_to group_path( @group )
		  else
			flash[:error] = 'There was an error creating the group.'
		  end
	  else
		  flash[:error] = 'The group could not be created!'
		  redirect_to groups_path
	  end

  end

  def edit
	  @group = get_group_by_id_or_name
  end

  def update 
	  @group = Group.find(params[:id])
	  if @group.update_attributes( params[:group] )
	  	flash[:notice] = 'Group updated'
	  else
		flash[:error] = 'The changes were not saved'
	  end
	  redirect_to @group
  end

  def upload
	  @group = Group.find(params[:id])
  end
  
  private
  def  get_group_by_id_or_name
	 params[:name] ? Group.find_by_name(params[:name]) : Group.find(params[:id])
  end

end
