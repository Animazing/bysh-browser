class UserSessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_user, :except => :destroy

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session].reverse_merge(:remember_me => true))
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to folders_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to "/"
  end
end
