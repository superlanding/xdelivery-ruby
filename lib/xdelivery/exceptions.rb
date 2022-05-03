module Xdelivery

  module Exceptions

    EXCEPTIONS_MAP = {}
  end

  class UnknownError < StandardError; end

  EXPECTED_STATUSES = {
    200 => 'Ok' ,
    401 => 'Unauthorized'
  }

  EXCEPTION_STATUSES = {
    404 => 'Not Found',
    500 => 'Internal Server Error',
  }

  EXCEPTION_STATUSES.each_pair do |code, message|
    klass = Class.new(StandardError) do
      send(:define_method, :message) { "#{code}, #{message}" }
    end
    klass_constant = const_set(message.delete(' \-\''), klass)
    Exceptions::EXCEPTIONS_MAP[code] = klass_constant
  end
end
