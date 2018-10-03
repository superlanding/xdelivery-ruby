module Xdelivery
  module API
    class Orders < Base
      include Enumerable

      attr_accessor :orders

      COLUMNS = [
        :order_id, :provider, :recipient, :mobile, :email, :store_id, :store_name, :address,
        :items, :warehouse_items, :total_order_amount, :cash_on_delivery, :order_created_at,
        :note, :callback_url, :ref_id
      ]

      def add(params)
        self.orders ||= []
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
        response = post('/orders/batch')
        Response::Orders.new(response)
      end

      protected

      def post_data
        { import: { orders: orders } }
      end
    end
  end
end
