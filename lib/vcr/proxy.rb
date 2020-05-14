# frozen_string_literal: true

require 'singleton'
require 'vcr/proxy/version'

module VCR
  module Proxy
    def self.config
      Config.instance
    end

    class Config
      include Singleton

      attr_accessor :endpoint
      attr_accessor :cassette_library_dir
      attr_accessor :record_mode
      attr_accessor :match_requests_on
      attr_accessor :port
      attr_accessor :bind

      def initialize
        @endpoint = 'https://example.com'
        @cassette_library_dir = 'fixtures/vcr_cassettes'
        @match_requests_on = %i[path query body method]
        @port = 8099
        @bind = '0.0.0.0'
        @record_mode = :once
      end
    end
  end
end
