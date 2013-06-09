require 'crudify/hook_methods'
require 'crudify/class_methods'
require 'crudify/base'

module Crudify
  class Engine < Rails::Engine
  end
end

ActionController::Base.send(:include, Crudify::Base)
