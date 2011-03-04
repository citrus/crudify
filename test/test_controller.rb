require 'helper'

class TestController < Test::Unit::TestCase

  def setup
    @controller = CrudifyTestController.new
  end
  
  should "render index" do
    puts @controller.index 
  end
  
end