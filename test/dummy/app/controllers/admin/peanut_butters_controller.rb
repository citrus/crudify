class Admin::PeanutButtersController < ApplicationController
  
  crudify :peanut_butter, :use_class_name_as_title => true
  
end