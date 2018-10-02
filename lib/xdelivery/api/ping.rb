module Xdelivery
  module API
    class Ping < Base

      def ping!
        data = JSON.parse(get('/'))
        data['status'] == true
      end
    end
  end
end
