class UsersController < ApplicationController
	def show
	    @user = User.find(params[:id])
	    @user_uploads = Upload.where("@uploads.user_id = ?", @user).order("created_at DESC").limit(8).page(params[:page]).per(8)
      	@banner = Upload.where("@uploads.user_id = ?", @user).order("created_at DESC").limit(1)
	end

  def new
  	@user = User.new 
  end
  
  def create
  	@user = User.new(params[:user])
    @user_session = UserSession.new(params[:user_session])
  	if @user.save
     flash[:notice] = "Registration successfull."
  		redirect_to proc { user_url(@user) }
  	else
  		render "new"
  	end
  end
    
    
  
    def edit
      @user = User.find(params[:id]) 
      authorize! :update, @user
    end
    
    def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice] ="successfull updated"
        redirect_to proc { user_url(@user) }

      else
        render 'edit'

      end
    end
    def poll_winners
      @user = User.find(params[:id]) 
        @score = @user.uploads
    end
    def my_facebook
       @friends = Array.new
       if session["fb_access_token"].present?
         @graph = Koala::Facebook::GraphAPI.new(session["fb_access_token"])
         #@profile_image = @graph.get_picture("me")
         #@fbprofile = @graph.get_object("1839323679")
         #@friends = @graph.get_connections("me", "friends")
         #@feed = @graph.get_connections("me", "likes")
         #@search = @graph.search("donnie")
         #@wall = @graph.put_wall_post("Hey, im playing around with my new site pikcam!!!!", {"picture" => @pics}, "")
        #@pic = @graph.put_picture(@pics)
        @pics = "http://s3.amazonaws.com/pik.pikcam.com/273/original.jpg?1352049026"
       end
    end
  def follow
    @user = User.find(params[:id])

    if current_user
      if current_user == @user
        flash[:error] = "You cannot follow yourself."
      else
        current_user.follow(@user)
        flash[:notice] = "You are now following #{@user.name}."
      end
    else
      flash[:error] = "You must <a href='/users/sign_in'>login</a> to follow #{@user.name}.".html_safe
    end
    respond_to do |format|
       format.js { redirect_to :back, :notice => " You are now following #{@user.name} "}
       end
  end
  def unfollow
      @user = User.find(params[:id])

      if current_user
        current_user.stop_following(@user)
        flash[:notice] = "You are no longer following #{@user.name}."
      else
        flash[:error] = "You must <a href='/users/sign_in'>login</a> to unfollow #{@user.name}.".html_safe
      end
      respond_to do |format|
       format.html { redirect_to :back }
       format.js { redirect_to :back, :notice => " You are now unfollowing #{@user.name} "}
        end
  end
end
