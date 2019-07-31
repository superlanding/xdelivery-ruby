require 'json'
require 'rest-client'
require "xdelivery/version"
require "xdelivery/callback"
require "xdelivery/client"
require "xdelivery/api/base"
require "xdelivery/api/orders"
require "xdelivery/api/sales"
require "xdelivery/api/products"
require "xdelivery/api/ping"
require "xdelivery/api/invoice_settings"
require "xdelivery/api/response/base"
require "xdelivery/api/response/orders"
require "xdelivery/api/response/products"
require "xdelivery/api/response/ping"
require "xdelivery/api/response/invoice_settings"


module Xdelivery
  def url
    API::Base::BASE_URL
  end
end
