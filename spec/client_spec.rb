require 'spec_helper'

describe 'Xdelivery::Client' do
  before do
    @merchant_no = "NN064000001"
    @access_key = "e965b2ff48b5aa7b4a7e61b62d2b4103"

    @client = Xdelivery::Client.new(@merchant_no, @access_key)
  end

  it "#merchant_no" do
    assert_equal @merchant_no, @client.merchant_no
  end

  it "#access_key" do
    assert_equal @access_key, @client.access_key
  end

  # it "#create_orders!" do
  #   @response = @client.create_orders! do |orders|
  #     params = {
  #       order_id: "SP19049",
  #       provider: "FAMI",
  #       recipient: "Eddie",
  #       mobile: "0976077777",
  #       email: "",
  #       store_id: 'F008263',
  #       store_name: '全家鳳山埤頂店',
  #       address: "高雄市鳳山區中山東路545號",
  #       items: "白水*1, 黑水*1",
  #       warehouse_items: [ { code: '白水', qty: 1 }, { code: '黑水', qty: 1 } ],
  #       total_order_amount: 1560,
  #       cash_on_delivery: true,
  #       order_created_at: "2018-04-12 15:23:31",
  #     }
  #     orders.add(params)
  #   end
  #   assert_equal "SP19049", @response.orders[0].order_id
  # end

  # it "test" do
  #   assert_equal true, @client.ping! 
  # end
end
