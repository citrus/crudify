require 'helper'

class DemoTest < ActionController::IntegrationTest
  
  should "visit the homepage" do
    visit "/"
    assert page.has_content?('Listing Jellies')
    assert page.has_content?('create a new jelly')
  end
  
  should "create a new jelly" do
    visit new_jelly_path # '/jellies/new'
    assert page.has_content?('New Jelly')    
    fill_in 'Title', :with => 'Capybara and Banana'
    fill_in 'Name', :with => 'Capyberry'
    click_button 'create'
    assert_equal jellies_path, current_path
    assert_flash(:notice, '"Capybara and Banana" was successfully created.')
    assert page.has_content?('Listing Jellies'), "Content should have title for index"
    assert page.has_content?('Capyberry'), "Content should contain name of new jelly"
  end
  
  context "with an existing jelly" do
    
    # wtf is going on here?
    setup do
      #@jelly = Jelly.create(:title => "Capygreen Times", :name => "Greenberry")
      @jelly = Jelly.last  
    end
    
    # wtf is going on here??
    should "show a jelly" do
      visit jelly_path(@jelly)
      assert page.has_content?('Show Jelly')
      assert page.has_content?(@jelly.title)
      assert page.has_content?(@jelly.name)
    end
   
   
   
    #should "update a jelly" do
    #  visit edit_jelly_path(@jelly)
    #  assert page.has_content?('Edit Jelly')
    #  fill_in 'Title', :with => 'Banana Capy'
    #  fill_in 'Name', :with => 'Capyberry and Banana'
    #  click_button 'update'
    #  assert_flash(:notice, '"Banana Capy" was successfully created.')
    #  #sleep 2
    #  #assert page.has_content?('Listing Jellies')
    #  #assert page.has_content?('Banana Capy')
    #  #assert page.has_content?('Capyberry and Banana')
    #end
    #
    #should "delete a jelly" do
    #  visit jelly_path(@jelly)
    #  assert page.has_content?('Show Jelly')
    #  evaluate_script 'window.confirm = function() { return true; }'
    #  click_link 'delete'
    #  
    #  assert_flash(:notice, '"#{@jelly.name}" was successfully created.')
    #  #sleep 2
    #  #assert page.has_content?('Listing Jellies')
    #  #assert !page.has_content?(@jelly.title)
    #  #assert !page.has_content?(@jelly.name)
    #end
    #
  end
  
end