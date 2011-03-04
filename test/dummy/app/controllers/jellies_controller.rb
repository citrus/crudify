class JelliesController < ApplicationController
  
  crudify :jelly, :redirect_to_url => "jellies_url"
  
end