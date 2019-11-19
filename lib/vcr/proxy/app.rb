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
      response = Faraday.post(uri, request.body.read, request_headers)
      relay_response(response)
    end
  end

  get '*' do
    vcr_wrapper('get') do
      uri = URI("#{VCR::Proxy.config.endpoint}#{request.path}")
      uri.query = URI.encode_www_form(request.params)
      response = Faraday.get(uri, request.params, request_headers)
      relay_response(response)
    end
  end

  def relay_response(response)
    puts response.headers.to_h
    status response.status
    response.body
  end

  def request_headers
    @request_headers ||= env.select { |k, _v| k.start_with? 'HTTP_' }
                            .collect { |key, val| [key.sub(/^HTTP_/, ''), val] }
                            .collect { |key, val| "#{key}: #{val}<br>" }
                            .sort
  end

  def vcr_wrapper(verb)
    key = "#{request.path}/#{verb}/#{request.params.to_json}"
    match_requests_on = VCR::Proxy.config.match_requests_on

    VCR.use_cassette(key, match_requests_on: match_requests_on) do
      yield
    end
  end
end
