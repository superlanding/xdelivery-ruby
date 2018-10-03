require 'json'
require "xdelivery/version"
require "xdelivery/client"
require "xdelivery/api/base"
require "xdelivery/api/orders"
require "xdelivery/api/ping"
require "xdelivery/api/response/base"
require "xdelivery/api/response/orders"
require "xdelivery/api/response/ping"


module Xdelivery
  def url
    API::Base::BASE_URL
  end
end
