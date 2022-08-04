require 'uri'
require 'rest-client'

module Xdelivery
  module API
    class Base
      attr_accessor :merchant_no, :access_key

      PRODUCTION_BASE_URL = 'https://api.xdelivery.io'
      TEST_BASE_URL = 'https://api.staging.xdelivery.io'

      def initialize(merchant_no='', access_key='')
        self.merchant_no = merchant_no
        self.access_key = access_key
      end

      def base_url
        @base_url = if ::Xdelivery.production?
          PRODUCTION_BASE_URL
        else
          TEST_BASE_URL
        end
      end

      protected

      def patch(path)
        RestClient::Request.execute(method: :patch, url: uri(path).to_s, payload: patch_data, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def post(path)
        RestClient::Request.execute(method: :post, url: uri(path).to_s, payload: post_data, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def get(path)
        RestClient::Request.execute(method: :get, url: uri(path).to_s, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def open_timeout
        Xdelivery.open_timeout
      end

      def read_timeout
        Xdelivery.read_timeout
      end

      # [GET] query string params
      def params
        {}
      end

      # [POST]
      def post_data
        {}
      end

      # [PATCH]
      def patch_data
        {}
      end

      private

      def uri(path)
        uri = URI.parse("#{base_url}#{path}").tap { |u| u.query = query_auth_params }
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
