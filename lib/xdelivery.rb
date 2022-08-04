require 'json'
require 'rest-client'
require "xdelivery/version"
require "xdelivery/callback"
require "xdelivery/client"
require "xdelivery/exceptions"
require "xdelivery/api/base"
require "xdelivery/api/orders"
require "xdelivery/api/sales"
require "xdelivery/api/products"
require "xdelivery/api/ping"
require "xdelivery/api/shops"
require "xdelivery/api/response/base"
require "xdelivery/api/response/orders"
require "xdelivery/api/response/products"
require "xdelivery/api/response/ping"
require "xdelivery/api/response/shops"


module Xdelivery

  @@open_timeout = 5
  @@read_timeout = 5

  @@env = :production

  def self.env(env)
    @@env
  end

  def self.env=(env)
    @@env = env
  end

  def self.open_timeout
    @@open_timeout
  end

  def self.open_timeout=(timeout)
    @@open_timeout = timeout
  end

  def self.read_timeout
    @@read_timeout
  end

  def self.read_timeout=(timeout)
    @@read_timeout = timeout
  end

  # Xdelivery.configure do |config|
  #   config.open_timeout = 5
  #   config.read_timeout = 5
  # end
  def self.configure
    yield(self)
  end

  def self.production?
    @@env.to_s == "production"
  end

  def self.test?
    @@env.to_s == "test"
  end
end
