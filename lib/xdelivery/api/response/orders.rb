module Xdelivery
  module API
    module Response
      class Orders < Base

        class Order < OpenStruct
          def valid?
            valid == true || errors.empty?
          end

          def errors
            super || []
          end
        end

        def orders
          data['orders'].map { |order| Order.new(order) }
        end
      end
    end
  end
end
