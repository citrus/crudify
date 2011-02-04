module Crudify

  module HookMethods
    
    private
      
      def before_create
        # just a hook!
        puts "> Crud::before_create"
        before_action
      end    
        
      def before_update
        # just a hook!
        puts "> Crud::before_update"
        before_action
      end    
        
      def before_destroy
        # just a hook!
        puts "> Crud::before_destroy"
        before_action
      end
      
      
      def before_action
        # just a hook!
        puts "> Crud::before_action"
        @what = @crud_options[:use_class_name_as_title] ? @instance.class.to_s.humanize : @instance.send(@crud_options[:title_attribute].to_sym).inspect
        true
      end
      
              
      
      def successful_create
        puts "> Crud::successful_create"
        
        flash[:notice] = t('crudify.created', :what => @what)
        
        after_success
      end
      
      def successful_update
        puts "> Crud::successful_update"
        
        flash[:notice] = t('crudify.updated', :what => @what)
        
        after_success
      end
      
      def successful_destroy
        puts "> Crud::successful_destroy"
        
        flash.notice = t('crudify.destroyed', :what => @what)
        
        after_success
      end
      
      def after_success
        puts "> Crud::after_success"
        
        unless request.xhr?
          if params[:commit].match(/continue/)
            if params[:action] == 'create'
              redirect_to request.referer.sub('new', "#{what.to_param}/edit")
            else
              redirect_to request.referer
            end            
          else
            redirect_back_or_default eval(@crud_options[:redirect_to_url])
          end
        else
          render :partial => "/shared/message"
        end
        
      end
      
      
      
      
      def failed_create
        puts "> Crud::failed_create"
        
        flash[:error] = t('crudify.failed_create', :what => @what)
        
        after_fail
      end
      
      def failed_update
        puts "> Crud::failed_update"
        
        flash[:error] = t('crudify.failed_update', :what => @what)
        
        after_fail
      end
      
      def failed_destroy
        puts "> Crud::failed_destroy"
        
        flash[:error] = t('crudify.failed_destroy', :what => @what)
        
        after_fail
      end
    
    
      def after_fail
        puts "> Crud::after_fail"
        
        unless request.xhr?
          render :action => request.post? ? 'new' : 'edit'
        else          
          flash[:error] = [flash[:error], what.errors.collect{|key,value| "#{key} #{value}"}.join("<br/>")]
          render :partial => "/shared/message"
        end
      end
      
  
    end

end