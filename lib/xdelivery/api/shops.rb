module Xdelivery
  module API
    class Shops < Base
      def get!
        Response::Shops.new(get('/shops.json'))
      end
    end
  end
end
