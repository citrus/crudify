require_relative 'helper'


def assert_has_method?(methods, name)
  
end

	
class TestController < Test::Unit::TestCase

  def setup
    @controller = CrudifyTestController.new 
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
    assert_equal 3, jellies.length
  end
  
  #should "paginate collection" do
  #  jellies = @controller.send(:paginate_all_jellies)
  #  assert_equal 2, jellies.total_pages
  #  assert_equal 3, jellies.total_entries
  #end
  
  
end