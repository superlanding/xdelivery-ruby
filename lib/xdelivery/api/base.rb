require 'uri'
require 'rest-client'

module Xdelivery
  module API
    class Base
      attr_accessor :merchant_no, :access_key

      BASE_URL = 'https://api.xdelivery.io'

      def initialize(merchant_no='', access_key='')
        self.merchant_no = merchant_no
        self.access_key = access_key
      end

      protected

      def post(path)
        RestClient.post(uri(path).to_s, post_data)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def get(path)
        RestClient.get(uri(path).to_s)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      # [GET] query string params
      def params
        {}
      end

      # [POST] 
      def post_data
        {}
      end

      private

      def uri(path)
        uri = URI.parse("#{BASE_URL}#{path}").tap { |u| u.query = query_auth_params }
      end

      def query_auth_params
        URI.encode_www_form(auth_params.merge(params))
      end

      def auth_params
        { merchant_no: merchant_no, access_key: access_key }
      end
    end
  end
end
