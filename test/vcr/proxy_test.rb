require "test_helper"

class VCR::ProxyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::VCR::Proxy::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end
