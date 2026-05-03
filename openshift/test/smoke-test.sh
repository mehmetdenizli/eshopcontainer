#!/bin/bash

# eShop on OpenShift Smoke Test Script
# This script checks the availability of all public endpoints.

NAMESPACE="eshop"
DOMAIN="apps-crc.testing"

echo "--------------------------------------------------"
echo "🚀 Starting eShop Smoke Test on OpenShift"
echo "--------------------------------------------------"

services=("webapp" "identity-api" "catalog-api" "basket-api" "ordering-api" "webhooks-api" "webhooksclient")

for svc in "${services[@]}"; do
    URL="http://$svc-$NAMESPACE.$DOMAIN"
    echo -n "Checking $svc ($URL)... "
    
    # Check if URL is reachable (Follow redirects with -L)
    STATUS=$(curl -o /dev/null -s -L -w "%{http_code}" $URL)
    
    if [[ "$STATUS" == "200" || "$STATUS" == "302" || "$STATUS" == "401" || "$STATUS" == "404" ]]; then
        echo -e "✅ UP (Status: $STATUS)"
    else
        echo -e "❌ DOWN (Status: $STATUS)"
    fi
done

echo "--------------------------------------------------"
echo "🔍 Checking Identity Discovery Document..."
ID_URL="http://identity-api-$NAMESPACE.$DOMAIN/.well-known/openid-configuration"
if curl -s $ID_URL | grep -q "issuer"; then
    echo "✅ Identity API OIDC Config is accessible."
else
    echo "❌ Identity API OIDC Config check failed!"
fi

echo "--------------------------------------------------"
echo "📋 Checking Catalog Items..."
CATALOG_URL="http://catalog-api-$NAMESPACE.$DOMAIN/api/catalog/items?api-version=1.0&pageSize=1"
if curl -s -L $CATALOG_URL | grep -q "data"; then
    echo "✅ Catalog API is returning items."
else
    echo "❌ Catalog API check failed!"
fi

echo "--------------------------------------------------"
echo "✨ Smoke Test Completed!"
