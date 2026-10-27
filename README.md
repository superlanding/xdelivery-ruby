# Xdelivery

[![Gem Version](https://badge.fury.io/rb/xdelivery.svg)](https://rubygems.org/gems/xdelivery)
[![Tests](https://github.com/superlanding/xdelivery-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/superlanding/xdelivery-ruby/actions/workflows/test.yml)

**XDelivery（火箭快遞）** 商家 API 的 Ruby client：可批次拋送訂單與銷貨（可附發票）、更新商品庫存數據、列出商店、ping API，以及驗證 XDelivery 回呼（callback）給你的請求。

> 這個 gem 在 RubyGems 上的名稱是 **`xdelivery`**（repo 與 gemspec 檔名為 `xdelivery-ruby`）；Ruby 的 namespace 是 `Xdelivery`。

## 環境需求

- Ruby `>= 2.7`（gemspec）。CI 會跑 Ruby **3.1、3.3 與 3.4**（見 [`.github/workflows/test.yml`](.github/workflows/test.yml)）。
- 不依賴 Rails。Runtime 相依套件：`rest-client >= 2.0` 與 `ostruct`。
- 由 XDelivery 核發的商家編號（`merchant_no`）與存取金鑰（`access_key`）。

## 安裝

```ruby
# Gemfile
gem "xdelivery"
```

```bash
bundle install
```

或執行 `gem install xdelivery`，再 `require "xdelivery"`。

## 設定

所有設定都是選填的，下面列出的是預設值。

```ruby
# config/initializers/xdelivery.rb
Xdelivery.configure do |config|
  config.open_timeout = 5      # 建立連線的等待秒數
  config.read_timeout = 5      # 等待回應的秒數
end

Xdelivery.env = :production    # 除了 :production 之外，其他值都會連到 staging API
```

| 環境 | Base URL |
|-------------|----------|
| `:production`（預設） | `https://api.xdelivery.io` |
| 其他任何值，例如 `:test` | `https://api.staging.xdelivery.io` |

## 使用方式

用你的憑證建立 client。每個 API 方法都是 client 上的 bang 方法，並回傳一個 response 物件。

```ruby
client = Xdelivery::Client.new("YOUR_MERCHANT_NO", "YOUR_ACCESS_KEY")
```

### 建立訂單

`create_orders!` 會 yield 一個 builder；每筆訂單呼叫一次 `add(order_params, invoice_params = {})`，block 結束時會把整批送出。

```ruby
response = client.create_orders! do |orders|
  orders.add(
    {
      order_id: "SP19049",
      provider: "FAMI",
      recipient: "Eddie",
      mobile: "0976077777",
      email: "",
      store_id: "F008263",
      store_name: "全家鳳山埤頂店",
      address: "高雄市鳳山區中山東路545號",
      items: "白水*1, 黑水*1",
      warehouse_items: [{ code: "白水", qty: 1 }, { code: "黑水", qty: 1 }],
      total_order_amount: 1560,
      cash_on_delivery: true,
      order_created_at: "2018-04-12 15:23:31",
      note: "Helloworld",
      callback_url: "https://example.com/xdelivery/callback",
      ref_id: 22345
    },
    # 選填：發票
    { create_type: "device", device: "email", email: "buyer@example.com", items: [] }
  )
end

response.status?              # => API 接受這次請求時為 true
response.auth?                # => 憑證被拒絕（HTTP 401）時為 false
response.history_id           # => XDelivery 那邊的匯入紀錄 id（失敗時為 nil）
response.orders.each do |order|
  order.order_id
  order.valid?                # order.errors 不是空的時候為 false
  order.errors                # => []
end
```

訂單允許的 key：`order_id provider recipient mobile email store_id store_name address items warehouse_items total_order_amount cash_on_delivery order_created_at note callback_url ref_id tag merchant_note shop_id`。
發票允許的 key：`create_type email company_code company_title donate_code device_id device items`。
**其他的 key 會被 `add` 默默丟掉**，不會報錯。

#### 附加到既有的匯入紀錄（`history_id`）

傳入 `history_id:`，就能讓多次呼叫歸在 XDelivery 後台的同一筆匯入紀錄。空白的值（`nil`、`""`、只有空白字元）會被忽略，前後的空白也會被去除。

```ruby
first  = client.create_orders! { |orders| orders.add(order_a) }
second = client.create_orders!(history_id: first.history_id) { |orders| orders.add(order_b) }
```

### 建立銷貨

格式與訂單相同，用於銷貨批次；builder 是 `Xdelivery::API::Sales`，同樣支援 `history_id:`，回傳的也是 `Response::Orders`。

```ruby
response = client.create_sales! do |sales|
  sales.add({ order_id: "SP19050", recipient: "Eddie", tracking_code: "T123", total_order_amount: 100 })
end
```

銷貨允許的 key：`order_id recipient mobile email address items warehouse_items total_order_amount cash_on_delivery order_created_at note callback_url ref_id tag tracking_code merchant_note shop_id`（發票的 key 與訂單相同）。

### 更新商品

```ruby
response = client.update_products! do |products|
  products.set("迷黑", days_produce: 10, qty_day_average: 10, qty_week_average: 10, qty_month_average: 10, qty_owe: 10)
end
response.status?
```

允許的 key：`days_produce qty_day_average qty_week_average qty_month_average qty_owe`（其他的會被丟掉）。

### 商店與 ping

```ruby
shops = client.get_shops!
shops.status?
shops.shops.each { |shop| [shop.id, shop.title, shop.pay2go_merchant_id, shop.default_shop] }

client.ping!.status?
```

### 驗證 callback

XDelivery 會呼叫你在訂單上填的 `callback_url`。`Xdelivery::Callback` 負責檢查簽章（`check_code`，是以排序後的參數加上你的商家編號與存取金鑰所算出的 SHA-256）：

```ruby
# 例如在 Rails controller 裡（params 是 callback 請求的 params）
callback = Xdelivery::Callback.new(merchant_no, access_key, params.to_unsafe_h.symbolize_keys)

if callback.valid?
  callback.action       # 例如 "delivered"
  callback.title        # 例如 "消費者取貨"
  callback.desc
  callback.provider     # 例如 "fami"
  callback.created_at   # Time（有 ActiveSupport 的 Time.zone 時會用 Time.zone.parse）
                          # 在 Rails 以外的環境，請自行先 `require "time"`（這個 gem 只會呼叫 Time.parse）
end
```

### 錯誤處理

當 HTTP status 不是 `200` 或 `401` 時，response 物件會 raise：

| HTTP status | Exception |
|-------------|-----------|
| 404 | `Xdelivery::Client::NotFound` |
| 500 | `Xdelivery::Client::InternalServerError` |
| 502 | `Xdelivery::Client::BadGateway` |
| 503 | `Xdelivery::Client::ServiceUnavailable` |
| 504 | `Xdelivery::Client::GatewayTimeout` |
| 其他任何 status，或 body 不是 JSON | `Xdelivery::Client::UnknownResponse` |

網路逾時**不會**被包裝：`RestClient::Exceptions::OpenTimeout` / `ReadTimeout` 會原樣 raise，請自行 rescue：

```ruby
begin
  client.create_orders! { |orders| orders.add(order) }
rescue Xdelivery::Client::ServiceUnavailable, RestClient::Exceptions::Timeout
  # 稍後重試
end
```

`401` 不會 raise exception：請檢查 `response.auth?`。

## 開發

```bash
git clone https://github.com/superlanding/xdelivery-ruby.git
cd xdelivery-ruby
bin/setup
bundle exec rake t       # 以 Minitest + WebMock 執行 spec/**/*_spec.rb（預設的 rake task 也一樣）
bin/console
```

spec 以 WebMock 模擬 HTTP；`spec/real_client_spec.rb`（對真實伺服器發請求）目前被註解掉了。

## 發版

發版透過 RubyGems [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/) 自動完成（repo 內不存放 API key）：

1. 在你的 PR 裡修改 `lib/xdelivery/version.rb` 的 `Xdelivery::VERSION`（遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)）。
2. 在 `CHANGELOG.md` 新增對應的 `## [x.y.z] - YYYY-MM-DD` 區塊。
3. 由真人 review 後合併進 `master`（AI 帳號只能開 PR）。
4. [`.github/workflows/publish.yml`](.github/workflows/publish.yml) 會在 `master` 上執行：當 gemspec 的版本還沒上 rubygems.org 時，就執行 `rake release`（打 `vX.Y.Z` tag 並發佈）。沒有跳版號的合併不會發佈任何東西。

只改文件 / CI 的 PR 不需要跳版號。請見 [CLAUDE.md](CLAUDE.md)：每個 PR 也都必須更新 `README.md`（行為或用法有變時）並在 `CHANGELOG.md` 新增一筆條目。

## 貢獻

歡迎到 GitHub 回報問題與提交 pull request：https://github.com/superlanding/xdelivery-ruby。

## 授權

本 gem 以 [MIT License](https://opensource.org/licenses/MIT) 條款開源。
