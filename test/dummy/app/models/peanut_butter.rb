class PeanutButter < ActiveRecord::Base
  
  validates_presence_of :viscosity
  
  cattr_reader :per_page
  @@per_page = 3
    
end