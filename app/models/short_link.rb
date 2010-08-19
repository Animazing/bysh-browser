class ShortLink < ActiveRecord::Base
  validates_presence_of :path
  validates_uniqueness_of :hash
  
  belongs_to :user
end
