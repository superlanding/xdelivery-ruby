require 'spec_helper'

describe 'Xdelivery::Client' do
  before do
    @merchant_no = "QN009000001"
    @access_key = "5794bfd9664166ebd31aeaca857bf853"

    @api = Xdelivery::Client.new(@merchant_no, @access_key)
  end

  it "#merchant_no" do
    assert_equal @merchant_no, @api.merchant_no
  end

  it "#access_key" do
    assert_equal @access_key, @api.access_key
  end

  # it "#create_orders!" do
  #   @response = @api.create_orders! do |orders|
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
  #   assert_equal "F00000001111", @response.orders[0].ship_no
  # end
end
