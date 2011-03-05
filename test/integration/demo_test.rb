require 'helper'

class DemoTest < ActionController::IntegrationTest
  
  def setup
    Jelly.destroy_all
  end
  
  should "visit homepage with no jellies" do
    visit root_path
    assert page.has_content?('Listing Jellies')
    assert page.has_content?('create a new jelly')
    assert !page.has_content?('jelly named')
  end
  
  should "create a new jelly" do
    visit new_jelly_path
    assert page.has_content?('New Jelly')    
    fill_in 'Title', :with => 'Capybara and Banana'
    fill_in 'Name', :with => 'Capyberry'
    click_button 'create'    
    assert_equal jellies_path, current_path
    assert_flash(:notice, '"Capybara and Banana" was successfully created.')
    assert page.has_content?('Listing Jellies'), "Content should have title for index"
    assert page.has_content?('Capyberry'), "Content should contain name of new jelly"
  end
  
  context "an existing jelly" do
    
    setup do
      @jelly = Jelly.create(:title => "Capygreen Times", :name => "Greenberry") 
    end
    
    should "visit homepage with a jelly" do
      visit root_path
      assert page.has_content?('Listing Jellies')
      assert page.has_content?('create a new jelly')
      assert page.has_content?('jelly named Greenberry')
      assert has_link?('read', :href => jelly_path(@jelly))
      assert has_link?('update', :href => edit_jelly_path(@jelly))
    end
    
    should "be shown" do
      visit jelly_path(@jelly)
      assert page.has_content?('Show Jelly')
      within "#content" do
        assert page.has_content?(@jelly.title)
        assert page.has_content?(@jelly.name)
      end
    end
    
    should "get updated" do
      visit edit_jelly_path(@jelly)
      assert page.has_content?('Edit Jelly')
      fill_in 'Title', :with => 'Banana Capy'
      fill_in 'Name', :with => 'Capyberry and Banana'
      click_button 'update'
      assert_flash(:notice, '"Banana Capy" was successfully updated.')
      assert page.has_content?('Listing Jellies')
      within "#content" do
        assert page.has_content?('Capyberry and Banana')
      end
    end
    
    should "get deleted" do
      visit jelly_path(@jelly)
      assert page.has_content?('Show Jelly')
      evaluate_script 'window.confirm = function() { return true; }'
      click_link 'delete'
      assert_flash(:notice, %("#{@jelly.title}" was successfully removed.))
      assert page.has_content?('Listing Jellies')
      within "#content" do
        assert !page.has_content?(@jelly.name)
      end
    end
    
  end
  
end