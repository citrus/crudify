#
# Disclaimer:
#
# The majority of this was originally written by 
# the splendid fellows at Resolve Digital for their
# awesome refinerycms project.
#

module Crudify  

  module ClassMethods
    
     def crudify(model_name, options = {})
        
       puts model_name.inspect
       puts options.inspect
       
       options = ::Crudify::Base.default_options(model_name).merge(options)
       
       singular_name = model_name.to_s
       class_name = singular_name.camelize
       plural_name = singular_name.pluralize
       
       options[:paginate] = (options[:paginate] && eval(class_name).respond_to?(:paginate))
  
       module_eval %(
       
         # (Just a comment!)
         
         prepend_before_filter :find_#{singular_name},
                               :only => [:update, :destroy, :edit, :show]
         
         prepend_before_filter :set_crud_options                        
                               
         def set_crud_options
           @crud_options = #{options.inspect}
         end
                  
         def set_what
           return @what if @what
           what = @crud_options[:use_class_name_as_title] ? @instance.class.to_s.underscore.humanize : @instance.send(@crud_options[:title_attribute].to_sym).inspect
           what = @instance.class.to_s.underscore.humanize if what.nil? || what == '""'
           @what = what
         end
                  
         def index
         end                      
          
         def show
         end
          
         def new
           @#{singular_name} = #{class_name}.new
         end
  
  
         def create
           # if the position field exists, set this object as last object, given the conditions of this class.
           if #{class_name}.column_names.include?("position")
             params[:#{singular_name}].merge!({
               :position => ((#{class_name}.maximum(:position, :conditions => #{options[:conditions].inspect})||-1) + 1)
             })
           end
           @instance = @#{singular_name} = #{class_name}.create(params[:#{singular_name}])
           ok = before_create
           return ok unless ok === true
           if @instance.valid? && @instance.save  
             successful_create
           else
             failed_create
           end
         end
  
         def edit
           # object gets found by find_#{singular_name} function
         end
  
         def update
           ok = before_update
           return ok unless ok === true           
           if @#{singular_name}.update_attributes(params[:#{singular_name}])
             successful_update              
           else
             failed_update
           end
         end
  
         def destroy
           set_what
           ok = before_destroy
           return ok unless ok === true
           # object gets found by find_#{singular_name} function
           if @#{singular_name}.destroy
             successful_destroy
           else
             failed_destroy
           end
         end
  
  
  
  
         def set_instance(record)
           @instance = @#{singular_name} = record
         end
         
         def set_collection(scope, with_options=true)
           @collection = @#{plural_name} = with_options ? scope_with_options(scope) : scope
         end
  
         def scope_with_options(scope)
           scope.includes(
             #{options[:include].map(&:to_sym).inspect}
           )
         end
  
         # Finds one single result based on the id params.
         def find_#{singular_name}
           set_instance(#{class_name}.find(params[:id],
             :include => #{options[:include].map(&:to_sym).inspect}))
         end
         
         
         # Find the collection of @#{plural_name} based on the conditions specified into crudify
         # It will be ordered based on the conditions specified into crudify
         # And eager loading is applied as specified into crudify.
         def find_all_#{plural_name}(conditions = #{options[:conditions].inspect})
           set_collection(#{class_name}.where(conditions))
         end
                 
  
         # Paginate a set of @#{plural_name} that may/may not already exist.
         def paginate_all_#{plural_name}
           # If we have already found a set then we don't need to again
           find_all_#{plural_name} if @#{plural_name}.nil?
  
           paginate_options = {:page => params[:page]}
  
           # Seems will_paginate doesn't always use the implicit method.
           if #{class_name}.methods.map(&:to_sym).include?(:per_page)
             paginate_options.update(:per_page => #{class_name}.per_page)
           end
  
           set_collection(@#{plural_name}.paginate(paginate_options), false)
         end
  
         # Returns results based on the query specified by the user.
         def search_all_#{plural_name}
           params[:search] ||= {}
           params[:search][:meta_sort] ||= #{options[:order].to_s.downcase.gsub(' ', '.').inspect}
           @search ||= find_all_#{plural_name}.search(params[:search])
           set_collection(@search, false)
         end
  
  
         # Ensure all methods are protected so that they should only be called
         # from within the current controller.
         protected :find_#{singular_name},
                   :find_all_#{plural_name},
                   :paginate_all_#{plural_name},
                   :search_all_#{plural_name}
       )
  
       # Methods that are only included when this controller is searchable.
       if options[:searchable]
       
         module_eval %(
           def searching?
             params && !params[:search].nil?
           end
         )
         
         if options[:paginate]
           module_eval %(
             def index
               search_all_#{plural_name}
               paginate_all_#{plural_name}
             end
           )
         else
           module_eval %(
             def index
               unless searching?
                 find_all_#{plural_name}
               else
                 search_all_#{plural_name}
               end
             end
           )
         end
       else
         if options[:paginate]
           module_eval %(
             def index
               paginate_all_#{plural_name}
             end
           )
         else
           module_eval %(
             def index
               find_all_#{plural_name}
             end
           )
         end
  
       end
  
       if options[:sortable]
         module_eval %(
           def reorder
             find_all_#{plural_name}
           end
  
           # Based upon http://github.com/matenia/jQuery-Awesome-Nested-Set-Drag-and-Drop
           def update_positions
             previous = nil
             # The list doesn't come to us in the correct order. Frustration.
             0.upto((newlist ||= params[:ul]).length - 1) do |index|
               hash = newlist[index.to_s]
               moved_item_id = hash['id'].split(/#{singular_name}\\_?/)
               @current_#{singular_name} = #{class_name}.find_by_id(moved_item_id)
  
               if @current_#{singular_name}.respond_to?(:move_to_root)
                 if previous.present?
                   @current_#{singular_name}.move_to_right_of(#{class_name}.find_by_id(previous))
                 else
                   @current_#{singular_name}.move_to_root
                 end
               else
                 @current_#{singular_name}.update_attribute(:position, index)
               end
  
               if hash['children'].present?
                 update_child_positions(hash, @current_#{singular_name})
               end
  
               previous = moved_item_id
             end
  
             #{class_name}.rebuild! if #{class_name}.respond_to?(:rebuild!)
             render :nothing => true
           end
  
           def update_child_positions(node, #{singular_name})
             0.upto(node['children'].length - 1) do |child_index|
               child = node['children'][child_index.to_s]
               child_id = child['id'].split(/#{singular_name}\_?/)
               child_#{singular_name} = #{class_name}.find_by_id(child_id)
               child_#{singular_name}.move_to_child_of(#{singular_name})
  
               if child['children'].present?
                 update_child_positions(child, child_#{singular_name})
               end
             end
           end
  
         )
       end
         
     end
  
   end

end