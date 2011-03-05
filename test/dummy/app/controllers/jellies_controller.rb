class JelliesController < ApplicationController
  
  crudify :jelly, :redirect_to_url => "jellies_url", :order => "created_at DESC"
  
end