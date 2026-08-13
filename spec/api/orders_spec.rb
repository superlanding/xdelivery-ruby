require 'spec_helper'

describe 'Xdelivery::API::Orders' do

  before do
    @orders = Xdelivery::API::Orders.new
    @params = {
      order_id: "SP19049",
      provider: "FAMI",
      recipient: "Eddie",
      mobile: "0976077777",
      email: "",
      store_id: 'F008263',
      store_name: '全家鳳山埤頂店',
      address: "高雄市鳳山區中山東路545號",
      items: "白水*1, 黑水*1",
      warehouse_items: [ { code: '白水', qty: 1 }, { code: '黑水', qty: 1 } ],
      total_order_amount: 1560,
      cash_on_delivery: true,
      order_created_at: "2018-04-12 15:23:31",
    }
    @orders.add(@params)
  end

  it "#count == 1" do
    assert_equal 1, @orders.count
  end

  it "#to_json 應該要包含原始資料" do
    assert_equal [@params], @orders.orders
  end

  it "應該要跟丟入資料一樣" do
    assert_equal 'SP19049', @orders[0][:order_id]
    assert_equal 'FAMI', @orders[0][:provider]
    assert_equal 'Eddie', @orders[0][:recipient]
  end

  describe "#history_id" do
    it "沒有設定時 post_data 不帶 history_id" do
      assert_equal false, @orders.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成 nil 時 post_data 不帶 history_id" do
      @orders.history_id = nil
      assert_equal false, @orders.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成空字串時 post_data 不帶 history_id" do
      @orders.history_id = ""
      assert_equal false, @orders.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成空白字串時 post_data 不帶 history_id" do
      @orders.history_id = "  "
      assert_equal false, @orders.send(:post_data)[:import].key?(:history_id)
    end

    it "有設定時 post_data 帶著 history_id" do
      @orders.history_id = 5566
      assert_equal 5566, @orders.send(:post_data)[:import][:history_id]
    end

    it "設定成字串 id 時 post_data 原樣帶著 history_id" do
      @orders.history_id = "5566"
      assert_equal "5566", @orders.send(:post_data)[:import][:history_id]
    end

    it "orders 不受影響" do
      @orders.history_id = 5566
      assert_equal [@params], @orders.send(:post_data)[:import][:orders]
    end
  end
end
