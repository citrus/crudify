require 'helper'

	
class CrudifyTest < Test::Unit::TestCase

  def setup
  
    Jelly.destroy_all
    10.times{|i|
      Jelly.create(:title => "Yummy Jelly #{i}", :name => "Sample #{i}")
    }
  
    @controller = JelliesController.new 
    @controller.params = {}
  end
  
  should "have crud methods" do
    [
      :find_jelly,
      :find_all_jellies,
      :paginate_all_jellies,
      :search_all_jellies
    ].each do |method|
      assert @controller.methods.include?(method), "Should have #{method}"
    end    
  end
  
  should "have private hook methods" do
    [
      :before_create,
      :before_update,
      :successful_create,
      :successful_update,
      :successful_destroy,
      :after_success,
      :failed_create,
      :failed_update,
      :failed_destroy,
      :after_fail
    ].each do |method|
      assert @controller.private_methods.include?(method), "Should have #{method}"
    end
  end
  
  should "get collection" do
    jellies = @controller.send(:find_all_jellies)
    assert_equal 10, jellies.length, "Confirm 10 total jellies"
  end
  
  should "paginate collection" do
    jellies = @controller.send(:paginate_all_jellies)
    
    assert_equal 4, jellies.total_pages, "10 jellies, 3 per page = 4 pages"
    assert_equal 10, jellies.total_entries, "Confirm 10 total jellies"
  end  
  
end