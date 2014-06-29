class CategoriesController < ApplicationController
	def index
	@uploads_resta = Upload.order("created_at DESC").page(params[:page]).per(8)
	@categories = Category.order(:name)
	end

	def show 
		@category = Category.find(params[:id])
		@uploads_reste = @category.uploads.page(params[:page]).per(8).order("created_at DESC")
	end

	def new
		@category = Category.new
		
	end

	def create
	  @category = Category.new(params[:category])

	  if @category.save
	  	redirect_to proc { category_url(@category) }
	  	
	  end
		
	end
	def edit
      @category = Category.find(params[:id]) 
      authorize! :update, @user
  	end
    
    def update
      @category = Category.find(params[:id])
      if @category.update_attributes(params[:category])
        flash[:notice] ="successfull updated"
        redirect_to @category

      else
        render 'edit'

      end
    end	
end
