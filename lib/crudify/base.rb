# Base methods for CRUD actions
# Simply override any methods in your action controller you want to be customised
# Don't forget to add:
#   resources :plural_model_name_here
# to your routes.rb file.
# Full documentation about CRUD and resources go here:
# -> http://caboo.se/doc/classes/ActionController/Resources.html#M003716
# Example (add to your controller):
# crudify :foo, {:title_attribute => 'name'}


module Crudify

  module Base
  
    def self.default_options(model_name)
      singular_name = model_name.to_s
      class_name = singular_name.camelize
      plural_name = singular_name.pluralize
      this_class = class_name.constantize
      {
        :title_attribute => "title",
        :use_class_name_as_title => false,
        :order => ('position ASC' if this_class.table_exists? and this_class.column_names.include?('position')),
        :conditions => '',
        :sortable => true,
        :searchable => true,
        :include => [],
        :paging => true,
        :search_conditions => '',
        :redirect_to_url => "admin_#{plural_name}_url",
        :log => defined?(Rails) ? Rails.env != 'production' : true
      }
    end
  
    def self.append_features(base)
      super
      base.send(:include, Crudify::HookMethods)
      base.extend(Crudify::ClassMethods)
    end
  
  end

end