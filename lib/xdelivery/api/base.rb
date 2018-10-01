require 'uri'
require 'rest-client'
module Xdelivery
  module API
    class Base

      BASE_URL = 'https://api.xdelivery.io'

      def initialize(merchant_no='', access_key='')
        self.merchant_no = merchant_no
        self.access_key = access_key
      end

      protected

      def post(cmd, params)
        uri = URI.parse("#{BASE_URL}#{cmd}")
        uri.query = URI.encode_www_form(auth_params)
        response = RestClient.post(uri.to_s, params)
        Xdelivery::Response.new(response.body)
      end

      def auth_params
        { merchant_no: merchant_no, access_key: access_key }
      end
    end
  end
end
