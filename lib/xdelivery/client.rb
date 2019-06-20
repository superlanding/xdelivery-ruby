module Xdelivery
  class Client

    attr_accessor :merchant_no, :access_key

    def initialize(merchant_no, access_key)
      self.merchant_no = merchant_no
      self.access_key = access_key
    end

    def create_orders!
      api = API::Orders.new(merchant_no, access_key)
      yield(api)
      api.create!
    end

    def create_sales!
      api = API::Sales.new(merchant_no, access_key)
      yield(api)
      api.create!
    end

    def update_products!
      api = API::Products.new(merchant_no, access_key)
      yield(api)
      api.update!
    end

    def ping!
      api = API::Ping.new(merchant_no, access_key)
      api.ping!
    end
  end
end
