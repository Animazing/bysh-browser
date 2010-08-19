class FoldersController < ApplicationController

  def show
    if params[:path].blank?
      @path = @current_user.full_path
    else
      @path = @current_user.full_path + "/" + params[:path]
    end
    @home_folder = @current_user.full_path
  end
  
  def create
    path = params[:path]
    send_wrapper(path)
  end
  
  def zip
    streaming = false #params[:streaming] || 0
    
    relative_path = params[:path]
    absolute_path = @current_user.full_path + "/" + relative_path
    relative_containing_folder = relative_path.gsub(File.basename(relative_path),"")
    absolute_containing_folder = absolute_path.gsub(File.basename(relative_path),"")
    
    Dir.chdir(absolute_containing_folder)

    if streaming
      # LOOK AT THIS MESS!!! WIP WIP
      # response.headers['Content-Type'] = 'application/octet-stream'
      # response.headers['Content-Disposition'] = "attachment; filename=#{File.basename(relative_path)}.zip"      
      # p = IO.popen("zip -r - \"#{absolute_path}\"","r")
      # self.response_body do 
      #    p.read
      #  end
#      while !p.eof? do 
       # send_data p.read, :filename => "#{File.basename(relative_path)}.zip", :type => 'application/zip', :disposition => 'attachment'
 #     end
      # end
      return 
      # return
      # p = IO.popen("zip -r - #{relative_path}") 
      #p.readlines
      # send_data p.read, :filename => "preview.pdf", :type => 'application/pdf', :disposition => 'inline'
      
    else
      IO.popen("zip -r \"#{absolute_path}.\"zip \"#{relative_path}\"")
      flash[:notice] = "Zipping in background, check back later."
    end
    if relative_containing_folder.blank?
      redirect_to folders_path
    else
      redirect_to url_for(:controller => "folders", :action => "show", :path => relative_containing_folder)
    end
  end

end