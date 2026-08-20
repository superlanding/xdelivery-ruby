require 'spec_helper'

describe 'Xdelivery::API::Base' do

  before do
    @api = Xdelivery::API::Base.new('YOUR_MERCHANT_NO', 'YOUR_ACCESS_KEY')
  end

  it "#auth_params" do
    assert_equal 'YOUR_MERCHANT_NO', @api.send("auth_params")[:merchant_no]
    assert_equal 'YOUR_ACCESS_KEY', @api.send("auth_params")[:access_key]
  end

  it "#query_auth_params" do
    assert_equal 'merchant_no=YOUR_MERCHANT_NO&access_key=YOUR_ACCESS_KEY', @api.send(:query_auth_params)
  end

  it "#uri" do
    assert_equal 'https://api.xdelivery.io/?merchant_no=YOUR_MERCHANT_NO&access_key=YOUR_ACCESS_KEY', @api.send(:uri, '/').to_s
  end

  it "#open_timeout" do
    assert_equal 5, @api.send(:open_timeout)
    Xdelivery.configure do |config|
      config.open_timeout = 10
    end
    assert_equal 10, @api.send(:open_timeout)
  end

  it "#read_timeout" do
    assert_equal 5, @api.send(:read_timeout)
    Xdelivery.configure do |config|
      config.read_timeout = 8
    end
    assert_equal 8, @api.send(:read_timeout)
  end

  describe "連線逾時" do
    it "timeout 要原樣拋出，不能被 rescue 成 nil" do
      # RestClient 的 timeout 例外是 ExceptionWithResponse 的子孫（經由 408 RequestTimeout），
      # 但它的 response 是 nil。被 rescue 接住並回傳 e.response 的話，呼叫端拿到 nil，
      # 接著在 Response::Base 裡 nil.code 噴 NoMethodError —— 完全看不出原因是逾時
      stub_request(:post, /xdelivery/).to_timeout

      assert_raises(RestClient::Exceptions::Timeout) do
        @api.send(:post, '/orders/batch.json')
      end
    end

    it "HTTP 錯誤回應仍然要回傳 response，不能一起被拋出" do
      stub_request(:post, /xdelivery/).to_return(status: 500, body: 'oops')

      response = @api.send(:post, '/orders/batch.json')
      assert_equal 500, response.code
    end
  end
end
