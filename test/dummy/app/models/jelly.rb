class Jelly < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :name
    
end