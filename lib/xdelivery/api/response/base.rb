module Xdelivery
  module API
    module Response
      class Base
        attr_accessor :response, :data

        def initialize(response)
          self.response = response
          self.data = begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            { 'status' => false }
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
      end
    end
  end
end
