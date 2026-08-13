require 'spec_helper'

describe 'Xdelivery::API::Sales' do

  before do
    @sales = Xdelivery::API::Sales.new
    @params = {
      order_id: "SP19049",
      recipient: "Eddie",
      mobile: "0976077777",
      email: "",
      address: "高雄市鳳山區中山東路545號",
      items: "白水*1, 黑水*1",
      warehouse_items: [ { code: '白水', qty: 1 }, { code: '黑水', qty: 1 } ],
      total_order_amount: 1560,
      cash_on_delivery: true,
      order_created_at: "2018-04-12 15:23:31",
      tracking_code: "902345678901",
    }
    @sales.add(@params)
  end

  it "#count == 1" do
    assert_equal 1, @sales.count
  end

  it "#to_json 應該要包含原始資料" do
    assert_equal [@params], @sales.sales
  end

  it "應該要跟丟入資料一樣" do
    assert_equal 'SP19049', @sales[0][:order_id]
    assert_equal 'Eddie', @sales[0][:recipient]
    assert_equal '902345678901', @sales[0][:tracking_code]
  end

  describe "#history_id" do
    it "沒有設定時 post_data 不帶 history_id" do
      assert_equal false, @sales.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成 nil 時 post_data 不帶 history_id" do
      @sales.history_id = nil
      assert_equal false, @sales.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成空字串時 post_data 不帶 history_id" do
      @sales.history_id = ""
      assert_equal false, @sales.send(:post_data)[:import].key?(:history_id)
    end

    it "設定成空白字串時 post_data 不帶 history_id" do
      @sales.history_id = "  "
      assert_equal false, @sales.send(:post_data)[:import].key?(:history_id)
    end

    it "有設定時 post_data 帶著 history_id" do
      @sales.history_id = 5566
      assert_equal 5566, @sales.send(:post_data)[:import][:history_id]
    end

    it "設定成字串 id 時 post_data 原樣帶著 history_id" do
      @sales.history_id = "5566"
      assert_equal "5566", @sales.send(:post_data)[:import][:history_id]
    end

    it "sales 不受影響" do
      @sales.history_id = 5566
      assert_equal [@params], @sales.send(:post_data)[:import][:orders]
    end
  end
end
