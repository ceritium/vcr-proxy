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
      response = Faraday.post(request_uri, request.body.read, request_headers)
      relay_response(response)
    end
  end

  put '*' do
    vcr_wrapper('put') do
      response = Faraday.put(request_uri, request.body.read, request_headers)
      relay_response(response)
    end
  end

  patch '*' do
    vcr_wrapper('patch') do
      response = Faraday.patch(request_uri, request.body.read, request_headers)
      relay_response(response)
    end
  end

  delete '*' do
    vcr_wrapper('delete') do
      response = Faraday.delete(request_uri, {}, request_headers)
      relay_response(response)
    end
  end

  get '*' do
    vcr_wrapper('get') do
      response = Faraday.get(request_uri, {}, request_headers)
      relay_response(response)
    end
  end

  def relay_response(response)
    status response.status
    response.body
  end

  def request_uri
    uri = URI("#{VCR::Proxy.config.endpoint}#{request.path}")
    uri.query = URI.encode_www_form(request.params)
    uri
  end

  def request_headers
    selected_headers = env.select { |k, _v| k.start_with? 'HTTP_' }.each_with_object({}) do |item, object|
      object[item[0].sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')] = item[1]
    end

    selected_headers.delete('Host')
    selected_headers.delete('Accept-Encoding')

    selected_headers
  end

  def vcr_wrapper(verb)
    key = "#{request.path}/#{verb}/#{request.params.to_json}"
    match_requests_on = VCR::Proxy.config.match_requests_on
    record_mode = VCR::Proxy.config.record_mode

    VCR.use_cassette(key, match_requests_on: match_requests_on, decode_compressed_response: true, record: record_mode) do
      yield
    end
  end
end
