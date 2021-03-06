module Xdelivery
  module API
    class Orders < Base
      include Enumerable

      attr_accessor :orders

      COLUMNS = [
        :order_id, :provider, :recipient, :mobile, :email, :store_id, :store_name, :address,
        :items, :warehouse_items, :total_order_amount, :cash_on_delivery, :order_created_at,
        :note, :callback_url, :ref_id, :tag, :merchant_note, :shop_id
      ]

      INVOICE_COLUMNS = [
        :create_type, :email, :company_code, :company_title, :donate_code, :device_id, :device, :items
      ]

      def add(params, invoice_params={})
        self.orders ||= []
        (params || {}).delete_if do |k, v|
          COLUMNS.include?(k) == false
        end
        invoice_params.delete_if do |k, v|
          INVOICE_COLUMNS.include?(k) == false
        end

        params.merge!(invoice: invoice_params) unless invoice_params.empty?

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
        response = post('/orders/batch.json')
        Response::Orders.new(response)
      end

      protected

      def post_data
        { import: { orders: orders } }
      end
    end
  end
end
