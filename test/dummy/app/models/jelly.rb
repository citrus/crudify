class Jelly < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :name
  
  cattr_reader :per_page
  @@per_page = 3
    
end