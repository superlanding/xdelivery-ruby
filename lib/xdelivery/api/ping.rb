module Xdelivery
  module API
    class Ping < Base
      def ping!
        Response::Ping.new(get('/'))
      end
    end
  end
end
