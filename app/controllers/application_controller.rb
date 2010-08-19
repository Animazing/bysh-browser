class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_user
  
  private
  
  def require_admin_user
     unless current_user && current_user.is_admin?
       flash[:notice] = "You must be logged in to access this page"
       redirect_to new_user_sessions_path
       return false
     end
   end

   def require_user
      unless current_user
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_sessions_url
        return false
      end
   end

   def current_user_session
     return @current_user_session if defined?(@current_user_session)
     @current_user_session = UserSession.find(User.first)
   end

   def current_user
     return @current_user if defined?(@current_user)
     @current_user = current_user_session && current_user_session.user
   end
end
