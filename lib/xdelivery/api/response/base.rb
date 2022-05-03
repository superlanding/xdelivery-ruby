module Xdelivery
  module API
    module Response
      class Base
        attr_accessor :response, :data

        def initialize(response)
          self.response = response
          handle_error!
          self.data = JSON.parse(response.body)
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
          exception = Xdelivery::EXCEPTION_STATUSES[code]
          if Xdelivery::EXCEPTION_STATUSES[code]
            raise Xdelivery::Exceptions::EXCEPTIONS_MAP[code]
          end

          unless Xdelivery::EXPECTED_STATUSES[code]
            raise Xdelivery::UnknownError
          end
        end
      end
    end
  end
end
