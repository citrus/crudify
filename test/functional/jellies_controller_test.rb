require 'helper'

class JelliesControllerTest < ActionController::TestCase
  
  should "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jellies)
  end
  
  should "get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:jelly)
  end
  
  should "post to create" do
    count1 = Jelly.count    
    post :create, :jelly => { :title => "Controller Jelly", :name => "Controlaberry" }
    assert_redirected_to jellies_path
    assert_equal (count1 + 1), Jelly.count
  end
    
  context "with a jelly" do
    
    setup do
      @jelly = Jelly.last
    end
      
    should "get show" do
      get :show, :id => @jelly.id
      assert_response :success
      assert_not_nil assigns(:jelly)
    end
    
    should "get edit" do
      get :edit, :id => @jelly.id
      assert_response :success
      assert_not_nil assigns(:jelly)   
    end    
    
    should "put update" do
      put :update, :id => @jelly.id, :jelly => { :title => "Updated Controller Jelly", :name => "Controlafresh" }
      assert_redirected_to jellies_path
    end 
    
    should "delete, destroy and maybe conquer" do
      count1 = Jelly.count    
      delete :destroy, :id => @jelly.id
      assert_redirected_to jellies_path
      assert_equal (count1 - 1), Jelly.count
    end
    
  end
end