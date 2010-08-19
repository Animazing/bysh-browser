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
    send_data(path)
  end
  
  def zip
    require 'zip/zipfilesystem'

    # Setup some variables
    @path = params[:path]
    @working_path = @current_user.full_path + "/" + @path
    match = @working_path.match(/\/(\w+)$/)
    unless match.blank?
      @root_path = @working_path.match(/\/(\w+)$/)[0]
    else
      @root_path = @working_path
    end

    zip_name = "#{File.basename(@path)}.zip"
    zip_path = @current_user.full_path + "/" + zip_name
    
    # What ever happens we want to make sure we delete any temp zipfiles we might have
    begin
      # If we are working with a folder traverse it recursive and add all enties
      if File.directory?(@working_path)
        Dir.chdir(@working_path)
      
        Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE) do |zipfile|
          @zipfile = zipfile
          # start in the current_folder
          pack_dir(Dir.pwd)
        end
      else
        # Zipping file
        Zip::ZipFile.open(zip_path, Zip::ZipFile::CREATE) do |zipfile|
          zipfile.file.open(File.basename(@working_path), "w") do |f|
            f.puts File.open(@working_path,"r").read
          end  
        end
      end
      # send the file to the browser
      send_data(zip_name)
    ensure
      # clean up the tmp file
      if File.exists?(zip_path)
        FileUtils.rm(zip_path)
      end
    end
  end
  
  private
  
  def pack_dir(folder, first_level = false)
    Dir.foreach(folder).each do |content|
      full_path = folder + "/" + content  
      short_path = @path + "/" + content
      local_path = folder.split(@root_path)
      if local_path.size <= 1
        local_path = "/"+ content
      else
        local_path = local_path[1]  + "/" + content
      end
      
      # skip internal linux links
      next if [".",".."].include?(content)
      # Go a level deeper if it's a folder
      if File.directory?(full_path)
       # Rails.logger.info("Creating folder: #{@root_path + "/" + content}")
        # @zipfile.dir.mkdir(@root_path + "/" + content)
        Rails.logger.info("Traversing to: #{full_path}")
        pack_dir(full_path)
      else
        # If not add the file
        Rails.logger.info("Creating file: #{local_path}")
        @zipfile.file.open(local_path, "w") do |f|
          f.puts File.open(full_path,"r").read
        end
      end
    end
  end
end