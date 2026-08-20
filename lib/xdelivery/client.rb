module Xdelivery
  class Client

    attr_accessor :merchant_no, :access_key

    def initialize(merchant_no, access_key)
      self.merchant_no = merchant_no
      self.access_key = access_key
    end

    # history_id 帶值時，這批訂單會掛進火箭快遞既有的匯入紀錄，
    # 讓多次呼叫在對方後台合併成同一筆 history
    def create_orders!(history_id: nil)
      api = API::Orders.new(merchant_no, access_key)
      api.history_id = history_id
      yield(api)
      api.create!
    end

    def create_sales!(history_id: nil)
      api = API::Sales.new(merchant_no, access_key)
      api.history_id = history_id
      yield(api)
      api.create!
    end

    def update_products!
      api = API::Products.new(merchant_no, access_key)
      yield(api)
      api.update!
    end

    def get_shops!
      API::Shops.new(merchant_no, access_key).get!
    end

    def ping!
      api = API::Ping.new(merchant_no, access_key)
      api.ping!
    end
  end
end
