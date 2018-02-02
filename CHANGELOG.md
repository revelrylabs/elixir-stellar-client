# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2018-02-01
### Added
- `KeyPair`
  * `from_secret/1` for getting a key pair from a secret
  * `random/0` for generating a new key pair
- `Operations`
  * `all_for_ledger/1` and `all_for_ledger/2` for listing operations for a ledger
- `Effects`
  * `all_for_operation/1` and `all_for_operation/2` for listing effects for an operation
  * `all_for_ledger/1` and `all_for_ledger/2` for listing effects for an operation
- `Payments`
  * `all_for_ledger/1` and `all_for_ledger/2` for listing payments for a ledger
- `Transactions`
  * `all_for_ledger/1` and `all_for_ledger/2` for listing transactions for a ledger
  * `post/1` for posting a transaction
- `Ledgers`
  * `get/1` for getting ledger details
  * `all/0` and `all/1` for listing ledgers in the system
- `Trades`
  * `all/0` and `all/1` for listing trades in the system
  * `all_for_order_book/2` and `all_for_order_book/3` for listing trades for an order book
- `OrderBook`
  * `get/1` for getting order book details
- `PaymentPaths`
  * `all/3` and `all/4` for listing payment paths
- `TradeAggregations`
  * `all/2` and `all/3` for listing trade aggregations

## [0.1.1] - 2018-01-27
### Fixed
- Make tests more reliable

## [0.1.0] - 2018-01-27
### Added
- `Accounts`
  * `get/1` for getting account details
  * `get_data/2` for getting data associated with account
- `Assets`
  * `all/0` and `all/1` for listing assets in the system
- `Effects`
  * `get/1` for getting effect details
  * `all/0` and `all/1` for listing effects in the system
  * `all_for_account/1` and `all_for_account/2` for listing effects for an account
- `Offers`
  * `all_for_account/1` and `all_for_account/2` for listing offers for an account
- `Operations`
  * `get/1` for getting operation details
  * `all/0` and `all/1` for listing operations in the system
  * `all_for_account/1` and `all_for_account/2` for listing operations for an account
- `Payments`
  * `all/0` and `all/1` for listing payments in the system
  * `all_for_account/1` and `all_for_account/2` for listing payments for an account
- `Transactions`
  * `get/1` for getting transaction details
  * `all/0` and `all/1` for listing transactions in the system
  * `all_for_account/1` and `all_for_account/2` for listing transactions for an account
