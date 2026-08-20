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

      # NOTICE: rescue 的順序不可以對調。
      # RestClient 的 timeout 例外是 ExceptionWithResponse 的子孫（經由 408 RequestTimeout），
      # 但它的 response 是 nil。若被下面那條接住並回傳 e.response，呼叫端會拿到 nil，
      # 接著在 Response::Base 裡 nil.code 噴 NoMethodError —— 完全看不出原因是逾時。
      # 逾時要原樣往外拋，讓呼叫端自己決定怎麼處理
      def patch(path)
        RestClient::Request.execute(method: :patch, url: uri(path).to_s, payload: patch_data, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::Exceptions::Timeout
        raise
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def post(path)
        RestClient::Request.execute(method: :post, url: uri(path).to_s, payload: post_data, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::Exceptions::Timeout
        raise
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end

      def get(path)
        RestClient::Request.execute(method: :get, url: uri(path).to_s, open_timeout: open_timeout, read_timeout: read_timeout)
      rescue RestClient::Exceptions::Timeout
        raise
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

      # 空字串／只有空白（例如表單沒填的欄位）跟 nil 一樣視為「不掛既有紀錄」，
      # 送出去只會讓對方拿到一個無效的 id。有值的字串則去掉前後空白才送，
      # 不然貼上來的 " 5566 " 會被序列化成 import[history_id]=+5566+
      def history_id_payload(history_id)
        id = history_id.respond_to?(:strip) ? history_id.strip : history_id
        return {} if id.to_s.empty?

        { history_id: id }
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
