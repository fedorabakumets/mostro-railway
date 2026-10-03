#!/bin/sh
set -eu
: "${MOSTRO_NSEC:?MOSTRO_NSEC is required}"
: "${MOSTRO_RELAY_URL:?MOSTRO_RELAY_URL is required}"
: "${CASHU_MINT_URL:?CASHU_MINT_URL is required}"
mkdir -p /config
cat > /config/settings.toml << ENDCFG
[lightning]
lnd_cert_file = '/config/lnd/tls.cert'
lnd_macaroon_file = '/config/lnd/admin.macaroon'
lnd_grpc_host = 'https://127.0.0.1:10009'
invoice_expiration_window = 3600
hold_invoice_cltv_delta = 144
hold_invoice_expiration_window = 300
payment_attempts = 3
payment_retries_interval = 60
max_final_cltv_expiry_delta = 144
escrow_deadline_margin_blocks = 24
max_inflight_payouts = 100
max_inflight_payouts_per_destination = 10
payment_cltv_limit = 1008
allow_node_change = false

[nostr]
nsec_privkey = '${MOSTRO_NSEC}'
relays = ['${MOSTRO_RELAY_URL}']

[mostro]
fee = 0.006
max_routing_fee = 0.002
max_order_amount = 1000000
min_payment_amount = 100
expiration_hours = 24
max_expiration_days = 15
expiration_seconds = 900
user_rates_sent_interval_seconds = 3600
publish_relays_interval = 60
pow = 0
publish_mostro_info_interval = 300
bitcoin_price_api_url = "https://api.yadio.io"
fiat_currencies_accepted = ['USD', 'EUR', 'RUB']
max_orders_per_response = 10
dev_fee_percentage = 0
name = "Railway study node"
about = "Cashu test escrow on a fake mint. No real funds."

[database]
url = "sqlite:///config/mostro.db"

[expiration]
order_days = 30
rating_days = 90
dispute_days = 90
fee_audit_days = 365
dm_days = 30

[rpc]
enabled = false
listen_address = "127.0.0.1"
port = 50051

[cashu]
enabled = true
mint_url = "${CASHU_MINT_URL}"
escrow_locktime_days = 15
ENDCFG
exec /usr/local/bin/mostrod -d /config
