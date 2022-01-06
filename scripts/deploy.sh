#!/bin/bash

# unlock wallet
cleos wallet unlock --password $(cat ~/eosio-wallet/.pass)

# create accounts
cleos create account eosio flash.sx 0x10Ff5ED1CC38173815465A3ADe74A02A794920e7
cleos create account eosio basic 0x10Ff5ED1CC38173815465A3ADe74A02A794920e7
cleos create account eosio callback 0x10Ff5ED1CC38173815465A3ADe74A02A794920e7
cleos create account eosio eosio.token 0x10Ff5ED1CC38173815465A3ADe74A02A794920e7
cleos create account eosio myaccount 0x10Ff5ED1CC38173815465A3ADe74A02A794920e7

# deploy
cleos set contract flash.sx . flash.sx.wasm flash.sx.abi
cleos set contract eosio.token . eosio.token.wasm eosio.token.abi
cleos set contract basic . basic.wasm basic.abi
cleos set contract callback . callback.wasm callback.abi

# permission
cleos set account permission flash.sx active --add-code
cleos set account permission basic active --add-code
cleos set account permission callback active --add-code
cleos set account permission myaccount active callback --add-code

# create EOS token
cleos push action eosio.token create '["eosio", "100000000.0000 EOS"]' -p eosio.token
cleos push action eosio.token issue '["eosio", "5000000.0000 EOS", "init"]' -p eosio
cleos transfer eosio myaccount "50000.0000 EOS" "init"

# open token balances
cleos transfer eosio flash.sx "100.0000 EOS"
cleos push action eosio.token open '["basic", "4,EOS", "basic"]' -p basic
cleos push action eosio.token open '["myaccount", "4,EOS", "myaccount"]' -p myaccount
