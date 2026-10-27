# 更新紀錄（Changelog）

本檔記錄此專案所有值得注意的變更。

格式參考 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/)，版本號遵循 [Semantic Versioning](https://semver.org/lang/zh-TW/)。

## [Unreleased]

### Added

- 新增 `CHANGELOG.md`。
- 完整的 `README.md`：概述、環境需求、安裝、設定、每支 API 的用法、錯誤處理、開發與發版流程。
- CLAUDE.md 規則：每個 PR 都必須同步更新 `README.md` 與 `CHANGELOG.md`；`README.md` 與 `CHANGELOG.md` 一律用繁體中文撰寫。

### Changed

- `README.md`、`CHANGELOG.md` 改以繁體中文（zh-TW）撰寫。

## [2.1.0] - 2026-10-27

### Added

- `Client#create_orders!` 與 `Client#create_sales!` 新增 `history_id:` 選項：把一批資料附加到 XDelivery 端既有的匯入紀錄，讓多次呼叫合併成同一筆紀錄。空白的值（`nil`、`""`、只有空白字元）視為未提供，前後的空白會被去除。
- `Response::Orders#history_id`（該批資料所附加的匯入紀錄；response 失敗時為 `nil`）。
- 支援 Ruby 3.3 與 3.4：`required_ruby_version >= 2.7`，並明確相依與 require `ostruct`。
- GitHub Actions 測試矩陣（Ruby 3.1.7、3.3.12、3.4.11）與 `publish.yml`（RubyGems Trusted Publishing）。
- CLAUDE.md 加入發版規則。

### Changed

- `rest-client` 相依版本改為 `>= 2.0`（`RestClient::Exceptions::Timeout` 需要）。
- `Rakefile` 的預設 task 改為 `t`。

### Fixed

- 請求逾時（`RestClient::Exceptions::Timeout`）以前會被吞掉，變成令人困惑的 `NoMethodError`（`nil.code`）。現在會原樣 raise。

## [2.0.3] - 2022-08-04

### Fixed

- 修正 2.0.0 之後的發版問題（2.0.2 從未發佈到 RubyGems）。

## [2.0.1] - 2022-08-04

### Fixed

- 修正 2.0.0 之後的發版問題（只有跳版號）。

## [2.0.0] - 2022-08-04

### Added

- 新增 `Xdelivery.env` / `Xdelivery.env=` 與 `Xdelivery.production?` / `Xdelivery.test?`。在 `production` 以外的任何環境，請求都會送到 staging API（`https://api.staging.xdelivery.io`）。
- 新增 `API::Base#base_url`、`PRODUCTION_BASE_URL` 與 `TEST_BASE_URL`。

### Removed

- 移除 `API::Base::BASE_URL`（由上述兩個常數取代）。

## [1.0.2] - 2022-05-04

### Added

- HTTP 錯誤回應的處理：`Client::NotFound`（404）、`Client::InternalServerError`（500）、`Client::BadGateway`（502）、`Client::ServiceUnavailable`（503）、`Client::GatewayTimeout`（504）與 `Client::UnknownResponse`（非 JSON 或非預期的 status）。

## [1.0.1] - 2020-04-22

### Added

- 新增 `Xdelivery.open_timeout`、`Xdelivery.read_timeout` 與 `Xdelivery.configure`。

## [1.0.0] - 2019-10-21

### Added

- 商店 API：`Client#get_shops!`，以及訂單 / 銷貨的 `shop_id` 欄位。

### Removed

- 移除發票設定 API（`Client#get_invoice_settings!`、`API::InvoiceSettings`）與發票的 `invoice_setting_id` 欄位。

## [0.2.4] - 2019-07-31

### Added

- 新增 `Xdelivery::Callback`，用來驗證 XDelivery callback 的 `check_code`。

## [0.2.3] - 2019-07-30

### Added

- 訂單與銷貨新增 `merchant_note`（系統備註）欄位。

## [0.2.2] - 2019-07-18

### Added

- 發票新增 `company_title` 欄位。

## [0.2.1] - 2019-07-17

### Added

- 銷貨的發票參數新增 `invoice_setting_id`。

## [0.2.0] - 2019-07-16

### Added

- 發票設定 API（`Client#get_invoice_settings!`）與發票的 `invoice_setting_id` 欄位（兩者在 1.0.0 又被移除）。

## [0.1.6] - 2019-06-21

### Fixed

- 修正銷貨 API 的問題。

## [0.1.5] - 2019-06-20

### Added

- 銷貨 API（`Client#create_sales!`）。

## [0.1.4] - 2019-06-13

### Added

- 發票品項（發票的 `items` 欄位）。

## [0.1.3] - 2019-06-12

### Changed

- 重新命名發票類型欄位。

## [0.1.2] - 2019-06-12

### Added

- 訂單支援開立發票。

## [0.1.1] - 2018-12-21

### Added

- 商品更新 API（`Client#update_products!`）。

## [0.1.0] - 2018-11-16

### Added

- 首次發佈。

[Unreleased]: https://github.com/superlanding/xdelivery-ruby/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/superlanding/xdelivery-ruby/releases/tag/v2.1.0
[2.0.3]: https://github.com/superlanding/xdelivery-ruby/commit/b0b5776
[2.0.1]: https://github.com/superlanding/xdelivery-ruby/commit/a82af2d
[2.0.0]: https://github.com/superlanding/xdelivery-ruby/commit/8d10d3a
[1.0.2]: https://github.com/superlanding/xdelivery-ruby/commit/e6a829e
[1.0.1]: https://github.com/superlanding/xdelivery-ruby/commit/53a9a6c
[1.0.0]: https://github.com/superlanding/xdelivery-ruby/commit/e4a25eb
[0.2.4]: https://github.com/superlanding/xdelivery-ruby/commit/c64600a
[0.2.3]: https://github.com/superlanding/xdelivery-ruby/commit/6a9a00e
[0.2.2]: https://github.com/superlanding/xdelivery-ruby/commit/410ee7a
[0.2.1]: https://github.com/superlanding/xdelivery-ruby/commit/82d7953
[0.2.0]: https://github.com/superlanding/xdelivery-ruby/commit/2853d8c
[0.1.6]: https://github.com/superlanding/xdelivery-ruby/commit/d6e1c7b
[0.1.5]: https://github.com/superlanding/xdelivery-ruby/commit/463d97b
[0.1.4]: https://github.com/superlanding/xdelivery-ruby/commit/22bd18d
[0.1.3]: https://github.com/superlanding/xdelivery-ruby/commit/c5c5890
[0.1.2]: https://github.com/superlanding/xdelivery-ruby/commit/5b36875
[0.1.1]: https://github.com/superlanding/xdelivery-ruby/commit/42c5f6b
[0.1.0]: https://github.com/superlanding/xdelivery-ruby/commit/f4b2c20
