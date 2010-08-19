class Admin::UsersController < InheritedResources::Base
  before_filter :require_admin_user
  
  def create
    create! { admin_users_path }
  end
  
  def update
    update!(:notice => "Account information updated.") { accounts_path }
  end
  
  def edit
    @user = current_user
  end
end