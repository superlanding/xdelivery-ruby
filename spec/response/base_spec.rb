require 'spec_helper'

describe 'Xdelivery::API::Response::Base' do
  describe "當沒有登入的情況 ..." do
    before do
      @data = "{\"status\":false}"
      stub_request(:any, Xdelivery::API::Base::BASE_URL).to_return(body: @data, status: 401)
      @http_response = begin
        RestClient.get(Xdelivery::API::Base::BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response  
      end

      @response = Xdelivery::API::Response::Orders.new(@http_response)
    end

    it "#auth? == false" do
      assert_equal false, @response.auth?
    end

    it "#status? == false" do
      assert_equal false, @response.status?
    end
  end

  describe "當正常登入的情況 ..." do
    before do
      @data = "{\"status\":true}"
      stub_request(:any, Xdelivery::API::Base::BASE_URL).to_return(body: @data, status: 200)
      @http_response = begin
        RestClient.get(Xdelivery::API::Base::BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response  
      end

      @response = Xdelivery::API::Response::Orders.new(@http_response)
    end

    it "#auth? == true" do
      assert @response.auth?
    end

    it "#status? == false" do
      assert @response.status?
    end
  end
end
