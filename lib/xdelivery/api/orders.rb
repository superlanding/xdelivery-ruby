module Xdelivery
  module API
    class Orders < Base
      include Enumerable

      attr_accessor :orders, :merchant_no, :access_key

      COLUMNS = [
        :order_id, :provider, :recipient, :mobile, :email, :store_id, :store_name, :address,
        :items, :warehouse_items, :total_order_amount, :cash_on_delivery, :order_created_at
      ]

      def initialize(*)
        super
        self.orders = []
      end

      def add(params)
        params.delete_if { |k, v| COLUMNS.include?(k) == false }
        orders.push(params)
        params
      end

      def [](index)
        orders[index]
      end

      def count
        orders.count
      end

      def create!
        post('/orders/batch', params)
      end

      protected

      def params
        { import: { orders: orders } }
      end

      def to_json
        orders.to_json
      end
    end
  end
end
