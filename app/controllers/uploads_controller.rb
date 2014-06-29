class UploadsController < ApplicationController
	def index
  if params[:tag]
    @search = Upload.search(params[:q])
    @uploads = @search.result.tagged_with(params[:tag]).order("created_at DESC").page(params[:page]).per(9)
    @search.build_condition
  elsif params[:user_id]
      @user = User.find(params[:user_id])
        @search = Upload.search(params[:q])
        @uploads = @search.result.where("@uploads.user_id = ?", @user).order("created_at DESC").page(params[:page]).per(9)
        @search.build_condition
  else
    @search = Upload.search(params[:q])
	    @uploads = @search.result.order("created_at DESC").page(params[:page]).per(9)
      @search.build_condition
  end
			
	end
	def new
		@upload = Upload.new 
	end

	def create
		@upload = Upload.new(params[:upload])
		@upload.user = current_user
		if @upload.save
			
			flash[:notice] = "Picture has been save"
			redirect_to proc { upload_url(@upload) }
		else
			 render "new"
		end
	end

	def show
		@upload = Upload.find(params[:id])
		@uploads = Upload.order("RANDOM ()")
		@users_like = Upload.plusminus_tally.limit(3)
	end

	def edit
      @upload = Upload.find(params[:id]) 
      authorize! :update, @upload
  	end
  	def update 
  		@upload = Upload.find(params[:id])
  		if @upload.update_attributes(params[:upload])
  			flash[:notice] = "Picture has been updated"
			redirect_to proc { upload_url(@upload) }
		else
			render "edit"
  		end
  	end

  def destroy
     @upload = Upload.find(params[:id])
     	@upload.destroy
     	redirect_to current_user, notice: "Successfully destroyed Picture."
     	authorize! :destroy, @upload
  end
    

  	def top
      @upload = Upload.new
  		@upload_top = Upload.plusminus_tally.page(params[:page]).per(8)
  		@videos_home = FunnyVideo.order("created_at DESC").limit(6)
  	end
    def feed
      @uploades = Upload.order(" created_at DESC")
      
      respond_to do |format|
      format.atom
      end
    end
    def upload_like 
      @upload = Upload.find(params[:id])
        respond_to do |format|
        if current_user.voted_for?(@upload)
          current_user.unvote_for(@upload)
         format.html { redirect_to :back, :notice => " You unlike the photo "}
         format.js { redirect_to :back, :notice => " you unlike the photo "}
         else
          current_user.vote_exclusively_for(@upload)
          format.html { redirect_to :back, :notice => " you like the photo!! "}
         format.js { redirect_to :back, :notice => " you like the photo!! "}
        end
        end
    end
end
