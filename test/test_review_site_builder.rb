require 'test/unit'
require 'review_site_builder'

class ReviewSiteBuilderTest < Test::Unit::TestCase
  
  def test_overall_build
    assert_equal true,
      ReviewSiteBuilder.build!("test/example_project/")
  end

end