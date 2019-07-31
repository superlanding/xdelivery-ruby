require 'spec_helper'

describe 'Xdelivery::Client' do
  before do
    @merchant_no = "TB086000010"
    @access_key = "2a1dd319c95535cb1f1cc25fe21476b3"
    @params = {
      action: "delivered",
      title: "消費者取貨",
      desc: "",
      provider: "fami",
      created_at: "2019-05-08 20:16:44 +0800",
      check_code: "299A26E8FD574DD79729FD8AF426E24C35F8CC32AC3AF88EF64975100661E095"
    }
    @callback = Xdelivery::Callback.new(@merchant_no, @access_key, @params)
  end

  it "#merchant_no" do
    assert_equal @merchant_no, @callback.merchant_no
  end

  it "#access_key" do
    assert_equal @access_key, @callback.access_key
  end

  it "#valid? = true" do
    assert_equal true, @callback.valid?
  end

  it "#action = delivered" do
    assert_equal 'delivered', @callback.action
  end

  it "#title = 消費者取貨" do
    assert_equal '消費者取貨', @callback.title
  end

  it "#created_at = 2019-05-08 20:16:44 +0800" do
    assert_equal @callback.created_at, Time.parse("2019-05-08 20:16:44 +0800")
  end
end
