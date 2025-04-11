#!/bin/bash

# Variables needed to complete the program; You can get the DNS Record ID running this command 
# curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records" -H "X-Auth-Email: <email>" -H "X-Auth-Key: <api_key>" -H "Content-Type: application/json"
# jq is required for this script to function
# For Debian based systems run $ sudo apt-get install jq

# ID of your domain
zone_id=
# ID of the DNS record you want to update
dns_record_id=
# Cloudflare account email
email=
# Cloudflare API key
api_key=
# DNS record you want to update
record_name=


# Store current IP address in variable
current_ip=$(curl -s https://api.ipify.org)

# Store IP address in Cloudflare in variable
cloudflare_ip=$(curl -s https://www.cloudflare.com/api/v4/zones/$zone_id/dns_records/$dns_record_id -H "X-Auth-Email: $email" -H "X-Auth-Key: $api_key" -H "Content-Type: application/json" | jq -r '.result.content')

# Check if current IP address matches IP address in Cloudflare
if [ "$current_ip" != "$cloudflare_ip" ]; then
  # Update IP address in Cloudflare
  curl -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_record_id" -H "X-Auth-Email: $email" -H "X-Auth-Key: $api_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$current_ip\",\"ttl\":1,\"proxied\":true}"
fi
