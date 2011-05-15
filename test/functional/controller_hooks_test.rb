require 'helper'

module HookAssertions

  # We'll store things we want to assert here for now, 
  # then run the assertions at teardown
  #
  #   assertions << [ :assert, true, "True is true!" ]
  #   assertions << [ :assert_not_nil, 1, "1 is not nil" ]
  #
  def assertions
    @assertions ||= []
  end
  
  
  private
  
  def before_create
    assertions << [ :assert_not_nil, @jelly, "Jelly should be assigned" ]
    assertions << [ :assert, @jelly.new_record?, "Jelly should be a new record" ]
    super
  end
  
  def before_update
    assertions << [ :assert_not_nil, @jelly, "Jelly should be assigned" ]
    assertions << [ :assert, !@jelly.new_record?, "Jelly should not be a new record" ]
    super
  end
  
  ## not sure what to check for here...
  #def before_action
  #  assertions << [ :assert, true ]
  #  super
  #end
  
  def successful_create
    assertions << [ :assert, !@jelly.new_record?, "Jelly should not be a new record" ]
    super
  end
  
  def successful_update
    assertions << [ :assert_equal, @jelly.name, "Controlafresh" ]
    assertions << [ :assert, !@jelly.changed?, "Should be clean" ]
    super
  end
  
  def successful_destroy
    @old_jelly = Jelly.find(@jelly.id) rescue nil
    assertions << [ :assert, @old_jelly.nil? ]
    super
  end
  
  def after_success
    assertions << [ :assert_not_nil, flash[:notice], "Should have a notice" ]
    assertions << [ :assert, flash[:error].nil?, "Should not have an error message" ]
    super
  end
  
  def failed_create 
    assertions << [ :assert, !@jelly.errors.empty?, "Jelly has errors" ]
    super
  end
  
  def failed_update
    assertions << [ :assert, @jelly.changed?, "Jelly has unsaved updates" ]
    super
  end
  
  def failed_destroy
    @old_jelly = Jelly.find(@jelly.id) rescue nil
    assertions << [ :assert_not_nil, @old_jelly ]
    super
  end
  
  def after_fail
    assertions << [ :assert_not_nil, flash[:error].nil?, "Should have an error message" ]
    assertions << [ :assert, flash[:notice].nil?, "Should not have a notice" ]
    super
  end
  
end    


class ControllerHooksTest < ActionController::TestCase
  
  def setup
    # assertions will be created in the included module  
    JelliesController.send(:include, HookAssertions)
    @controller = JelliesController.new
  end
  
  def teardown
    # fire any assertions we saved in the controller
    @controller.assertions.each do |args|
      send(*args)
    end
  end
  
  should "post to create" do
    post :create, :jelly => { :title => "Controller Jelly", :name => "Controlaberry" }
  end
  
  should "post to create and fail" do
    post :create, :jelly => { :title => "", :name => "" }
  end
    
  context "with a jelly" do
    
    setup do
      @jelly = Jelly.create(:title => "Controller Jelly", :name => "Controlaberry")
    end
    
    should "put update" do
      put :update, :id => @jelly.id, :jelly => { :title => "Updated Controller Jelly", :name => "Controlafresh" }
    end 
  
    should "put update and fail" do
      put :update, :id => @jelly.id, :jelly => { :title => "", :name => "" }
    end 
  
    should "delete, destroy and maybe conquer" do
      delete :destroy, :id => @jelly.id
    end
    
    should "delete but not destroy" do
      # overwrite the default destroy method..
      # is there a better way to do this?
      Jelly.class_eval do
        
        alias :aliased_destroy :destroy
        
        def destroy
          false
        end
      end

      delete :destroy, :id => @jelly.id
      
      # rewrite to the old method
      Jelly.class_eval do
        def destroy
          aliased_destroy
        end
      end      

    end
    
  end
  
end