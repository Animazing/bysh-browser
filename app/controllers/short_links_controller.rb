class ShortLinksController < InheritedResources::Base
  skip_before_filter :require_user
  
  respond_to :js
  
  def create
    hash = Digest::SHA1.hexdigest(params[:path] + current_user.id.to_s)
    @link = ShortLink.find_or_initialize_by_hash(hash)
    @link.path = params[:path]
    @link.user_id = current_user.id    
    @link.save
  end
  
  def show
    @link = ShortLink.find_by_hash(params[:id])
    @link.update_attribute(:counter, (@link.counter + 1))
    @home_folder = @link.path

    if @link.blank?
      render :text => "Link not found."
    end
  
    looking_for = @link.user.full_path + "/" + @link.path
    if File.exists?(looking_for)
      if File.directory?(looking_for)
        # secure browse at some point
        render :text => "Share is a folder."
      else
        send_data(@link.path, @link.user)
      end
    else
      render :text => "File/Folder not found."
    end
  end
end