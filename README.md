# Xdelivery

[![Gem Version](https://badge.fury.io/rb/xdelivery.svg)](https://rubygems.org/gems/xdelivery)
[![Tests](https://github.com/superlanding/xdelivery-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/superlanding/xdelivery-ruby/actions/workflows/test.yml)

Ruby client for the **XDelivery (火箭快遞)** merchant API: push orders and sales in batches, optionally with an invoice, update product stock figures, list shops, ping the API and verify the callbacks XDelivery sends back to you.

> The gem is published on RubyGems as **`xdelivery`** (the repository and gemspec file are named `xdelivery-ruby`); the Ruby namespace is `Xdelivery`.

## Requirements

- Ruby `>= 2.7` (gemspec). CI runs on Ruby **3.1, 3.3 and 3.4** (see [`.github/workflows/test.yml`](.github/workflows/test.yml)).
- No Rails dependency. Runtime dependencies: `rest-client >= 2.0` and `ostruct`.
- A merchant number (`merchant_no`) and access key (`access_key`) issued by XDelivery.

## Installation

```ruby
# Gemfile
gem "xdelivery"
```

```bash
bundle install
```

Or `gem install xdelivery`, then `require "xdelivery"`.

## Configuration

All settings are optional; the defaults are shown.

```ruby
# config/initializers/xdelivery.rb
Xdelivery.configure do |config|
  config.open_timeout = 5      # seconds to open the connection
  config.read_timeout = 5      # seconds to wait for the response
end

Xdelivery.env = :production    # anything other than :production talks to the staging API
```

| Environment | Base URL |
|-------------|----------|
| `:production` (default) | `https://api.xdelivery.io` |
| any other value, e.g. `:test` | `https://api.staging.xdelivery.io` |

## Usage

Create a client with your credentials. Every API method is a bang method on the client and returns a response object.

```ruby
client = Xdelivery::Client.new("YOUR_MERCHANT_NO", "YOUR_ACCESS_KEY")
```

### Create orders

`create_orders!` yields a builder; call `add(order_params, invoice_params = {})` for each order, and the batch is sent when the block returns.

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
    # optional invoice
    { create_type: "device", device: "email", email: "buyer@example.com", items: [] }
  )
end

response.status?              # => true when the API accepted the request
response.auth?                # => false when the credentials were rejected (HTTP 401)
response.history_id           # => import history id on XDelivery's side (nil on failure)
response.orders.each do |order|
  order.order_id
  order.valid?                # false when order.errors is not empty
  order.errors                # => []
end
```

Allowed order keys: `order_id provider recipient mobile email store_id store_name address items warehouse_items total_order_amount cash_on_delivery order_created_at note callback_url ref_id tag merchant_note shop_id`.
Allowed invoice keys: `create_type email company_code company_title donate_code device_id device items`.
**Any other key is silently dropped** by `add`.

#### Attach to an existing import history (`history_id`)

Pass `history_id:` to put several calls into the same import history on XDelivery's backend. A blank value (`nil`, `""`, whitespace) is ignored, and surrounding whitespace is stripped.

```ruby
first  = client.create_orders! { |orders| orders.add(order_a) }
second = client.create_orders!(history_id: first.history_id) { |orders| orders.add(order_b) }
```

### Create sales

Same shape as orders, for sales batches; the builder is `Xdelivery::API::Sales`, `history_id:` is supported, and the response is also a `Response::Orders`.

```ruby
response = client.create_sales! do |sales|
  sales.add({ order_id: "SP19050", recipient: "Eddie", tracking_code: "T123", total_order_amount: 100 })
end
```

Allowed sale keys: `order_id recipient mobile email address items warehouse_items total_order_amount cash_on_delivery order_created_at note callback_url ref_id tag tracking_code merchant_note shop_id` (invoice keys as for orders).

### Update products

```ruby
response = client.update_products! do |products|
  products.set("迷黑", days_produce: 10, qty_day_average: 10, qty_week_average: 10, qty_month_average: 10, qty_owe: 10)
end
response.status?
```

Allowed keys: `days_produce qty_day_average qty_week_average qty_month_average qty_owe` (others are dropped).

### Shops and ping

```ruby
shops = client.get_shops!
shops.status?
shops.shops.each { |shop| [shop.id, shop.title, shop.pay2go_merchant_id, shop.default_shop] }

client.ping!.status?
```

### Verify a callback

XDelivery calls the `callback_url` you gave on an order. `Xdelivery::Callback` checks the signature (`check_code`, a SHA-256 over the sorted parameters plus your merchant number and access key):

```ruby
# e.g. in a Rails controller (params is the callback request's params)
callback = Xdelivery::Callback.new(merchant_no, access_key, params.to_unsafe_h.symbolize_keys)

if callback.valid?
  callback.action       # e.g. "delivered"
  callback.title        # e.g. "消費者取貨"
  callback.desc
  callback.provider     # e.g. "fami"
  callback.created_at   # Time (Time.zone.parse when ActiveSupport's Time.zone is available)
                          # outside Rails, `require "time"` yourself first (the gem only calls Time.parse)
end
```

### Error handling

The response object raises when the HTTP status is not `200` or `401`:

| HTTP status | Exception |
|-------------|-----------|
| 404 | `Xdelivery::Client::NotFound` |
| 500 | `Xdelivery::Client::InternalServerError` |
| 502 | `Xdelivery::Client::BadGateway` |
| 503 | `Xdelivery::Client::ServiceUnavailable` |
| 504 | `Xdelivery::Client::GatewayTimeout` |
| any other status, or a body that is not JSON | `Xdelivery::Client::UnknownResponse` |

Network timeouts are **not** wrapped: `RestClient::Exceptions::OpenTimeout` / `ReadTimeout` are raised as-is, so rescue them yourself:

```ruby
begin
  client.create_orders! { |orders| orders.add(order) }
rescue Xdelivery::Client::ServiceUnavailable, RestClient::Exceptions::Timeout
  # retry later
end
```

A `401` is not an exception: check `response.auth?`.

## Development

```bash
git clone https://github.com/superlanding/xdelivery-ruby.git
cd xdelivery-ruby
bin/setup
bundle exec rake t       # runs spec/**/*_spec.rb with Minitest + WebMock (the default rake task does too)
bin/console
```

The specs stub HTTP with WebMock; `spec/real_client_spec.rb` (calls against a real server) is commented out.

## Releasing

Releases are automated with RubyGems [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/) (no API key in the repo):

1. In your PR, bump `Xdelivery::VERSION` in `lib/xdelivery/version.rb` ([Semantic Versioning](https://semver.org/)).
2. Add a matching `## [x.y.z] - YYYY-MM-DD` section to `CHANGELOG.md`.
3. A human reviews and merges the PR into `master` (AI accounts can only open PRs).
4. [`.github/workflows/publish.yml`](.github/workflows/publish.yml) runs on `master`: when the gemspec version is not on rubygems.org yet it runs `rake release` (tags `vX.Y.Z` and publishes). A merge without a version bump publishes nothing.

Docs/CI-only PRs do not need a version bump. See [CLAUDE.md](CLAUDE.md): every PR must also update `README.md` (when behavior or usage changes) and add an entry to `CHANGELOG.md`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/superlanding/xdelivery-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
