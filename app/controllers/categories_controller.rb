class CategoriesController < ApplicationController

  before_filter :login_required
  before_filter :set_nav
  before_filter :can_edit_categories?

  def edit
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:notice] = 'Category successfully created'
    else
      flash[:notice] = 'Category could not be created'
    end

    redirect_to bio_bytes_path

  end

  def destroy
    cat = Category.find(params[:id])
    cat.bio_bytes.each do |byte|
      byte.category = Category.find_by_name("Other")
      byte.save
    end

    unless cat.name == "Other"
      cat.destroy
    else
      flash[:error] = "Cannot delete the 'Other' category"
    end

    redirect_to bio_bytes_path
  end

  def update
    @category = Category.find(params[:id])
    
    if @category.update_attributes(params[:category])
      redirect_to bio_bytes_path
    else
      render edit_category_path(@category)
    end

  end

  private

  def set_nav
	  @navbar_selected = :parts
  end

  def can_edit_categories?
    unless current_user.can_edit_categories?
      redirect_to bio_bytes_path
    end
  end

end
