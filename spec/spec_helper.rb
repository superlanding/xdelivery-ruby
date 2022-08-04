$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "minitest/autorun"
require 'minitest/stub_const'
require "xdelivery"
require 'json'
require 'webmock/minitest'


module Minitest
  class Test

    def fake_resp(*args)
      stub_request(:any, Xdelivery::API::Base::PRODUCTION_BASE_URL).to_return(*args)

      begin
        RestClient.get(Xdelivery::API::Base::PRODUCTION_BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end
  end
end
