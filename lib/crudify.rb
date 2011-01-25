require 'active_support'
require 'active_record'
require 'action_controller'

require 'crudify/hook_methods'
require 'crudify/class_methods'
require 'crudify/base'

module Crudify  
end

ActionController::Base.send(:include, Crudify::Base)