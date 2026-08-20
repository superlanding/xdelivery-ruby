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

        # 這批訂單被掛在哪一筆匯入紀錄底下。
        # 失敗的回應不會帶（沒有任何訂單寫入），此時是 nil
        def history_id
          data['history_id']
        end
      end
    end
  end
end
