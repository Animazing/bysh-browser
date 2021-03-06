class User < ActiveRecord::Base
	 acts_as_authentic do |c|
	   c.ignore_blank_passwords = true
   end
   
   has_many :short_links

	 validates_presence_of :login, :home_folder
	 validates_confirmation_of :password_confirmation, :on => :create, :message => "should match confirmation"
	 validates_length_of :password, :minimum => 6, :on => :create
	 validates_format_of :login, :with => /^[a-zA-Z][a-zA-Z0-9]+$/, :on => :create
	 
	 def full_path
	   $PREFIX_PATH + self.home_folder
   end
end