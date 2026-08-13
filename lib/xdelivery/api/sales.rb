module Xdelivery
  module API
    class Sales < Base
      include Enumerable

      # history_id: 掛進火箭快遞既有匯入紀錄的 id，nil 則由對方新建一筆
      attr_accessor :sales, :history_id

      COLUMNS = [
        :order_id, :recipient, :mobile, :email, :address,
        :items, :warehouse_items, :total_order_amount, :cash_on_delivery, :order_created_at,
        :note, :callback_url, :ref_id, :tag, :tracking_code, :merchant_note, :shop_id
      ]

      INVOICE_COLUMNS = [
        :create_type, :email, :company_code, :company_title, :donate_code, :device_id, :device, :items
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
        import = { orders: sales }
        # 空字串（例如表單沒填的欄位）跟 nil 一樣視為「不掛既有紀錄」，
        # 送出去只會讓對方拿到一個無效的 id
        import[:history_id] = history_id unless history_id.to_s.strip.empty?
        { import: import }
      end
    end
  end
end
