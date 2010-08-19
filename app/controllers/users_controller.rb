class UsersController < InheritedResources::Base
  skip_before_filter :require_user
  def create
    create! { new_account_path }
  end
  
  def update
    update!(:notice => "Account information updated.") { accounts_path }
  end
  
  def edit
    @user = current_user
  end
end