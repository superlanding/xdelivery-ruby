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

  describe "#create_orders!" do
    before do
      stub_request(:post, /xdelivery/).to_return(body: '{"status":true,"orders":[]}')
    end

    it "history_id 會傳給 API::Orders" do
      api_history_id = :not_set
      @client.create_orders!(history_id: 5566) { |api| api_history_id = api.history_id }
      assert_equal 5566, api_history_id
    end

    it "沒帶 history_id 時是 nil" do
      api_history_id = :not_set
      @client.create_orders! { |api| api_history_id = api.history_id }
      assert_nil api_history_id
    end

    it "history_id 會出現在送出去的 payload 裡" do
      @client.create_orders!(history_id: " 5566 ") { |api| api.add(order_id: "SP19049") }

      assert_requested(:post, /xdelivery/) do |req|
        req.body.include?("import[history_id]=5566")
      end
    end

    it "沒帶 history_id 時 payload 不含 history_id" do
      @client.create_orders! { |api| api.add(order_id: "SP19049") }

      assert_requested(:post, /xdelivery/) do |req|
        req.body.include?("history_id") == false
      end
    end
  end

  describe "#create_sales!" do
    before do
      stub_request(:post, /xdelivery/).to_return(body: '{"status":true,"orders":[]}')
    end

    it "history_id 會傳給 API::Sales" do
      api_history_id = :not_set
      @client.create_sales!(history_id: 5566) { |api| api_history_id = api.history_id }
      assert_equal 5566, api_history_id
    end

    it "沒帶 history_id 時是 nil" do
      api_history_id = :not_set
      @client.create_sales! { |api| api_history_id = api.history_id }
      assert_nil api_history_id
    end

    it "history_id 會出現在送出去的 payload 裡" do
      @client.create_sales!(history_id: " 5566 ") { |api| api.add(order_id: "SP19049") }

      assert_requested(:post, /xdelivery/) do |req|
        req.body.include?("import[history_id]=5566")
      end
    end

    it "沒帶 history_id 時 payload 不含 history_id" do
      @client.create_sales! { |api| api.add(order_id: "SP19049") }

      assert_requested(:post, /xdelivery/) do |req|
        req.body.include?("history_id") == false
      end
    end
  end
end
