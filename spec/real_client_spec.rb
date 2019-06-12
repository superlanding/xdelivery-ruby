require 'spec_helper'

describe 'Xdelivery::Client (真實測試)' do

  def with_development!(&block)
    WebMock.allow_net_connect!
    Xdelivery::API::Base.stub_const(:BASE_URL, "http://api.xdelivery.test", &block)
  end

  before do
    @merchant_no = "YD017000016"
    @access_key = "65c80e1141b13bb3b204c2fa9b18ffba"
    @client = Xdelivery::Client.new(@merchant_no, @access_key)
  end

  it "#update_products!" do
    with_development! do
      @response = @client.update_products! do |products|
        params = {
          days_produce: 10, qty_day_average: 10, qty_week_average: 10,
          qty_month_average: 10, qty_owe: 10
        }
        products.set('迷黑', params)
        products.set('迷黃', params)
        products.set('迷黃X', params)
      end
      assert_equal true, @response.status?
    end
  end

  describe "#create_orders!" do
    before do
      @order_params = {
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
        note: "Helloworld",
        callback_url: "https://www.yahoo.com.tw",
        ref_id: 22345
      }
    end

    it "OK 拋送訂單 (沒有發票)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          orders.add(@order_params)
        end
      end
      assert_equal true, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
    end

    it "OK 拋送訂單 (發票: Email)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: "device",
            device: "email",
            email: "eddie.li.624@gmail.com"
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal true, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
    end

    it "FAILD 拋送訂單 (發票: Email 未設定)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: "device",
            device: "email",
            email: ""
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal false, @response.orders[0].valid?
      assert_equal false, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
      assert_equal "22345", @response.orders[0].ref_id
      assert_equal '不能為空白', @response.orders[0].errors['invoice_email']
    end

    it "OK 拋送訂單 (發票: 手機條碼)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: 'device',
            device: 'barcode',
            device_id: "/1+-.567"
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal true, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
    end

    it "FAILD 拋送訂單 (發票: 手機條碼，格式不符合)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: 'device',
            device: 'barcode',
            device_id: "12345"
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal false, @response.orders[0].valid?
      assert_equal false, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
      assert_equal "22345", @response.orders[0].ref_id
      assert_equal '手機條碼格式錯誤', @response.orders[0].errors['invoice_device_id']
    end

    it "OK 拋送訂單 (發票: 自然人憑證)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: 'device',
            device: 'personal_id',
            device_id: "ab12345678987654"
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal true, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
    end

    it "FAILD 拋送訂單 (發票: 自然人憑證，格式不符合)" do
      with_development! do
        @response = @client.create_orders! do |orders|
          invoice_params = {
            invoice_type: 'device',
            device: 'personal_id',
            device_id: "12345678987654"
          }
          orders.add(@order_params, invoice_params)
        end
      end
      assert_equal false, @response.orders[0].valid?
      assert_equal false, @response.status?
      assert_equal "SP19049", @response.orders[0].order_id
      assert_equal "22345", @response.orders[0].ref_id
      assert_equal '自然人憑證格式錯誤', @response.orders[0].errors['invoice_device_id']
    end
  end

  it "#ping!" do
    with_development! do
      @response = @client.ping!
    end
    assert_equal true, @response.auth?
    assert_equal true, @response.status?
  end
end
