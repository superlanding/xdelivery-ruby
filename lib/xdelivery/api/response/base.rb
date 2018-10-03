module Xdelivery
  module API
    module Response
      class Base
        attr_accessor :response, :data

        def initialize(response)
          self.response = response
          self.data = JSON.parse(response.body)
        end

        def auth?
          response.code == 200
        end

        def status?
          data['status'] == true
        end
      end
    end
  end
end
