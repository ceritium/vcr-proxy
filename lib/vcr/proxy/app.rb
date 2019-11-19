# frozen_string_literal: true

require 'sinatra/base'
require 'faraday'
require 'vcr'

# Sinatra App which proxy calls caching the response with VCR
class App < Sinatra::Base
  configure do
    set :bind, VCR::Proxy.config.bind
    set :port, VCR::Proxy.config.port
  end

  post '*' do
    vcr_wrapper('post') do
      uri = URI("#{VCR::Proxy.config}#{request.path}")
      uri.query = URI.encode_www_form(request.params)
      response = Faraday.post(uri, request.body.read, 'Content-Type' => 'application/json')
      status response.status
      response.body
    end
  end

  get '*' do
    vcr_wrapper('get') do
      uri = URI("#{VCR::Proxy.config.endpoint}#{request.path}")
      uri.query = URI.encode_www_form(request.params)
      response = Faraday.get(uri, request.params, {'Accept' => 'application/json'})
      status response.status
      response.body
    end
  end

  def vcr_wrapper(verb)
    key = "#{request.path}/#{verb}/#{request.params.to_json}"
    VCR.use_cassette(key, match_requests_on: VCR::Proxy.config.match_requests_on) do
      yield
    end
  end
end
