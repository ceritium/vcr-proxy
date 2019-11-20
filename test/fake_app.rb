# frozen_string_literal: true

require 'sinatra'
class VCR::Proxy::FakeApp < Sinatra::Base
  post '/post' do
    response_body.to_json
  end

  put '/put' do
    response_body.to_json
  end

  patch '/patch' do
    response_body.to_json
  end

  delete '/delete' do
    response_body.to_json
  end

  get '/get' do
    response_body.to_json
  end

  private

  def response_body
    {
      method: request.request_method,
      path: request.path,
      query_params: request.query_string,
      body: request.body.read,
      headers: request_headers
    }
  end

  def request_headers
    env.select { |k, _v| k.start_with? 'HTTP_' }
  end
end
