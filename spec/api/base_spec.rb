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
end