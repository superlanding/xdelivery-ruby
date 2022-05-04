module Xdelivery
  module API
    module Response
      class Base
        attr_accessor :response, :data

        def initialize(response)
          self.response = response
          handle_error!

          self.data = begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            raise Client::UnknownResponse, "#{code}, Response is not json."
          end
        end

        def code
          response.code
        end

        def auth?
          code == 200
        end

        def status?
          data['status'] == true
        end

        protected

        def handle_error!
          if Client::EXCEPTION_STATUSES[code]
            raise Exceptions::EXCEPTIONS_MAP[code]
          end

          unless Client::EXPECTED_STATUSES[code]
            raise Client::UnknownResponse, "Unexpected response status code: #{code}."
          end
        end
      end
    end
  end
end
