module Xdelivery
  module API
    class Products < Base
      include Enumerable

      attr_accessor :products

      COLUMNS = [
        :days_produce, :qty_day_average, :qty_week_average, :qty_month_average, :qty_owe
      ]

      def set(code, params)
        self.products ||= []
        params.delete_if { |k, v| COLUMNS.include?(k) == false }
        products.push(params.merge(code: code))
      end

      def update!
        response = patch('/products/update_all.json')
        Response::Products.new(response)
      end

      protected

      def patch_data
        { qtys: { products: products } }
      end
    end
  end
end
