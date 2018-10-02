require 'json'

module Xdelivery
  module API
    class Response
      attr_accessor :data

      class Order < OpenStruct
        def valid?
          valid == true || errors.empty?
        end

        def errors
          super || []
        end
      end

      def initialize(data)
        self.data = JSON.parse(data)
      end

      def status?
        data['status'] == true
      end

      def orders
        data['orders'].map { |order| Order.new(order) }
      end
    end
  end
end
