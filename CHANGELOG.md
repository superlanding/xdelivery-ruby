# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `CHANGELOG.md`.
- Full `README.md`: overview, requirements, installation, configuration, usage of every API, error handling, development and release flow.
- CLAUDE.md rule: every PR must also update `README.md` and `CHANGELOG.md`.

## [2.1.0] - 2026-10-27

### Added

- `history_id:` option for `Client#create_orders!` and `Client#create_sales!`: attach a batch to an existing import history on the XDelivery side, so several calls merge into one history. A blank (`nil`, `""`, whitespace) value is treated as absent and surrounding whitespace is stripped.
- `Response::Orders#history_id` (the history the batch was attached to; `nil` on a failed response).
- Support for Ruby 3.3 and 3.4: `required_ruby_version >= 2.7`, explicit `ostruct` dependency and require.
- GitHub Actions test matrix (Ruby 3.1.7, 3.3.12, 3.4.11) and `publish.yml` (RubyGems Trusted Publishing).
- CLAUDE.md release rules.

### Changed

- The `rest-client` dependency now requires `>= 2.0` (needed for `RestClient::Exceptions::Timeout`).
- `Rakefile` default task is now `t`.

### Fixed

- Request timeouts (`RestClient::Exceptions::Timeout`) used to be swallowed and surfaced as a confusing `NoMethodError` (`nil.code`). They are now raised as-is.

## [2.0.3] - 2022-08-04

### Fixed

- Release fixes after 2.0.0 (2.0.2 was never published to RubyGems).

## [2.0.1] - 2022-08-04

### Fixed

- Release fixes after 2.0.0 (version bump only).

## [2.0.0] - 2022-08-04

### Added

- `Xdelivery.env` / `Xdelivery.env=` and `Xdelivery.production?` / `Xdelivery.test?`. In any environment other than `production` requests go to the staging API (`https://api.staging.xdelivery.io`).
- `API::Base#base_url`, `PRODUCTION_BASE_URL` and `TEST_BASE_URL`.

### Removed

- `API::Base::BASE_URL` (replaced by the two constants above).

## [1.0.2] - 2022-05-04

### Added

- Error handling for HTTP error responses: `Client::NotFound` (404), `Client::InternalServerError` (500), `Client::BadGateway` (502), `Client::ServiceUnavailable` (503), `Client::GatewayTimeout` (504) and `Client::UnknownResponse` (non-JSON or unexpected status).

## [1.0.1] - 2020-04-22

### Added

- `Xdelivery.open_timeout`, `Xdelivery.read_timeout` and `Xdelivery.configure`.

## [1.0.0] - 2019-10-21

### Added

- Shops API: `Client#get_shops!`, and the `shop_id` order / sale column.

### Removed

- Invoice settings API (`Client#get_invoice_settings!`, `API::InvoiceSettings`) and the `invoice_setting_id` invoice column.

## [0.2.4] - 2019-07-31

### Added

- `Xdelivery::Callback` to verify XDelivery's callback `check_code`.

## [0.2.3] - 2019-07-30

### Added

- `merchant_note` (system note) order and sale column.

## [0.2.2] - 2019-07-18

### Added

- `company_title` invoice column.

## [0.2.1] - 2019-07-17

### Added

- `invoice_setting_id` in the sales invoice params.

## [0.2.0] - 2019-07-16

### Added

- Invoice settings API (`Client#get_invoice_settings!`) and the `invoice_setting_id` invoice column (both removed again in 1.0.0).

## [0.1.6] - 2019-06-21

### Fixed

- Fix in the sales API.

## [0.1.5] - 2019-06-20

### Added

- Sales API (`Client#create_sales!`).

## [0.1.4] - 2019-06-13

### Added

- Invoice items (`items` invoice column).

## [0.1.3] - 2019-06-12

### Changed

- Renamed the invoice type column.

## [0.1.2] - 2019-06-12

### Added

- Invoice support for orders.

## [0.1.1] - 2018-12-21

### Added

- Product update API (`Client#update_products!`).

## [0.1.0] - 2018-11-16

### Added

- Initial release.

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
