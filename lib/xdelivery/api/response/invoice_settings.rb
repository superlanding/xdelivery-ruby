module Xdelivery
  module API
    module Response
      class InvoiceSettings < Base

        Setting = Struct.new(:id, :title, :pay2go_merchant_id, :default_setting)

        def status?
          auth?
        end

        def settings
          data.map do |setting|
            Setting.new(setting['id'], setting['title'], setting['pay2go_merchant_id'], setting['default_setting'])
          end
        end
      end
    end
  end
end
