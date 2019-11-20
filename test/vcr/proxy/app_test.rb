# frozen_string_literal: true

require 'test_helper'
require 'rack/test'
require 'fake_app'

ENV['APP_ENV'] = 'test'

VCR::Proxy.config.endpoint = 'http://localhost:4567'
require 'vcr/proxy/app'

class VCR::Proxy::AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  @fakeapp = Thread.new do
    VCR::Proxy::FakeApp.run!
  end

  Minitest.after_run do
    @fakeapp.kill
  end

  def test_get
    get '/get?foo=bar', {}, 'X-FOO' => 'BAR'
    assert last_response.ok?

    parsed_body = JSON.parse(last_response.body)
    assert_equal 'GET', parsed_body['method']
    assert_equal '/get', parsed_body['path']
    assert_equal 'foo=bar', parsed_body['query_params']
  end

  def test_post
    post '/post?foo=bar', 'thebody', 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?

    parsed_body = JSON.parse(last_response.body)
    assert_equal 'POST', parsed_body['method']
    assert_equal '/post', parsed_body['path']
    assert_equal 'foo=bar', parsed_body['query_params']
    assert_equal 'thebody', parsed_body['body']
  end

  def test_put
    put '/put?foo=bar', 'thebody', 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?

    parsed_body = JSON.parse(last_response.body)
    assert_equal 'PUT', parsed_body['method']
    assert_equal '/put', parsed_body['path']
    assert_equal 'foo=bar', parsed_body['query_params']
    assert_equal 'thebody', parsed_body['body']
  end

  def test_patch
    patch '/patch?foo=bar', 'thebody', 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?

    parsed_body = JSON.parse(last_response.body)
    assert_equal 'PATCH', parsed_body['method']
    assert_equal '/patch', parsed_body['path']
    assert_equal 'foo=bar', parsed_body['query_params']
    assert_equal 'thebody', parsed_body['body']
  end

  def test_delete
    delete '/delete?foo=bar', {}, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?

    parsed_body = JSON.parse(last_response.body)
    assert_equal 'DELETE', parsed_body['method']
    assert_equal '/delete', parsed_body['path']
    assert_equal 'foo=bar', parsed_body['query_params']
  end
end
