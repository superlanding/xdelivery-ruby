module Xdelivery
  module API
    class Sales < Base
      include Enumerable

      attr_accessor :sales

      COLUMNS = [
        :order_id, :recipient, :mobile, :email, :address,
        :items, :warehouse_items, :total_order_amount, :cash_on_delivery, :order_created_at,
        :note, :callback_url, :ref_id, :tag, :tracking_code
      ]

      INVOICE_COLUMNS = [
        :create_type, :email, :company_code, :company_title, :donate_code, :device_id, :device, :items, :invoice_setting_id
      ]

      def add(params, invoice_params={})
        self.sales ||= []
        (params || {}).delete_if do |k, v|
          COLUMNS.include?(k) == false
        end
        invoice_params.delete_if do |k, v|
          INVOICE_COLUMNS.include?(k) == false
        end

        params.merge!(invoice: invoice_params) unless invoice_params.empty?

        sales.push(params)
        params
      end

      def [](index)
        sales[index]
      end

      def count
        sales.count
      end

      def create!
        response = post('/sales/batch.json')
        Response::Orders.new(response)
      end

      protected

      def post_data
        { import: { orders: sales } }
      end
    end
  end
end
