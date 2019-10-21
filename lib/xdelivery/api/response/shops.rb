module Xdelivery
  module API
    module Response
      class Shops < Base

        Shop = Struct.new(:id, :title, :pay2go_merchant_id, :default_shop)

        def status?
          auth?
        end

        def shops
          data.map do |setting|
            Shop.new(setting['id'], setting['title'], setting['pay2go_merchant_id'], setting['default_shop'])
          end
        end
      end
    end
  end
end
