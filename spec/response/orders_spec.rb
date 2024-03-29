require 'spec_helper'

describe 'Xdelivery::API::Response::Orders' do

  describe "當 merchant_no, access_key 登入情況" do
    describe "當訂單送出成功時 ..." do
      before do
        @data = "{\"status\":true,\"orders\":[{\"ship_no\":\"F00000001111\",\"order_id\":\"SP19049\"}]}"
        stub_request(:any, Xdelivery::API::Base::PRODUCTION_BASE_URL).to_return(body: @data)
        @http_response = RestClient.post(Xdelivery::API::Base::PRODUCTION_BASE_URL, {})

        @response = Xdelivery::API::Response::Orders.new(@http_response)
      end

      it "#status? == true" do
        assert @response.status?
      end

      it "#orders" do
        assert_equal 'F00000001111', @response.orders[0].ship_no
        assert_equal 'SP19049', @response.orders[0].order_id
      end
    end

    describe "當訂單送出失敗時 ..." do
      before do
        @data = "{\"status\":false,\"orders\":[{\"order_id\":\"SP19049\",\"valid\":false,\"errors\":[\"錯誤一\",\"錯誤二\"]},{\"order_id\":\"SP19049\",\"valid\":true}]}"
        stub_request(:any, Xdelivery::API::Base::PRODUCTION_BASE_URL).to_return(body: @data)
        @http_response = RestClient.post(Xdelivery::API::Base::PRODUCTION_BASE_URL, {})

        @response = Xdelivery::API::Response::Orders.new(@http_response)
      end

      it "#status? == false" do
        assert_equal false, @response.status?
      end

      it "#orders#valid" do
        assert_equal false, @response.orders[0].valid?
        assert @response.orders[1].valid?
      end

      it "#orders#errors" do
        assert_equal ['錯誤一', '錯誤二'], @response.orders[0].errors
        assert @response.orders[1].errors.empty?
      end
    end
  end
end
