require "xdelivery/version"
require "xdelivery/client"
require "xdelivery/api/base"
require "xdelivery/api/orders"
require "xdelivery/api/ping"
require "xdelivery/api/orders/response"

module Xdelivery
  def url
    API::Base::BASE_URL
  end
end
