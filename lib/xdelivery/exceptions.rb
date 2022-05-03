module Xdelivery

  module Exceptions

    EXCEPTIONS_MAP = {}
  end

  class Client
    class UnknownResponse < StandardError; end

    EXPECTED_STATUSES = {
      200 => 'Ok' ,
      401 => 'Unauthorized'
    }

    EXCEPTION_STATUSES = {
      404 => 'Not Found',
      500 => 'Internal Server Error',
      502 => 'Bad Gateway',
      503 => 'Service Unavailable',
      504 => 'Gateway Timeout',
    }

    EXCEPTION_STATUSES.each_pair do |code, message|
      klass = Class.new(StandardError) do
        send(:define_method, :message) { "#{code}, #{message}" }
      end
      const_name = message.delete(',\.\-\'\"').split(' ').map(&:capitalize).join
      klass_constant = const_set(const_name, klass)
      Exceptions::EXCEPTIONS_MAP[code] = klass_constant
    end
  end
end
