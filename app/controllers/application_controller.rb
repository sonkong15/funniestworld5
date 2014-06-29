class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied, :with => :not_allow


  helper_method :current_user_session, :current_user, :facebook_token, :links, :uploadphoto
  
 
  private
  
  def links
    @links = Link.all
    
  end

  def not_allow
    redirect_to root_url, :notice => "sorry wrong URL"
  end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def facebook_token
      if current_user.present?
        current_user.id == @user.id
      else
        
      end
      
    end
end
