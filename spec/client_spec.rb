require 'spec_helper'

describe 'Xdelivery::Client' do
  before do
    @merchant_no = "NA052000001"
    @access_key = "fb88b4151c1cfdce4c62f482bc286323"

    @client = Xdelivery::Client.new(@merchant_no, @access_key)
  end

  it "#merchant_no" do
    assert_equal @merchant_no, @client.merchant_no
  end

  it "#access_key" do
    assert_equal @access_key, @client.access_key
  end
end
