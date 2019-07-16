module Xdelivery
  module API
    class InvoiceSettings < Base
      def get!
        Response::InvoiceSettings.new(get('/invoice_settings.json'))
      end
    end
  end
end
