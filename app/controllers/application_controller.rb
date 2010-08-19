class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_user
  
  private
  # file sending
  def send_data(path, user = current_user)
    if Byshbrowser::Application.config.action_dispatch.x_sendfile_header.blank? 
      send_file(user.full_path + "/"+  path)
    else
      send_nginx(path)
    end
  end
  
  def send_nginx(path, user = current_user)
    response.headers['X-Accel-Redirect'] = "/xdownload/" + user.home_folder + "/" + path
    response.headers['Content-Type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = "attachment; filename=#{File.basename(path)}"
    render :nothing => true
  end

  # auth
  
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
