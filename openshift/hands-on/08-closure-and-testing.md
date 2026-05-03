# Step 08: Testing and Project Closure - Hands-on Guide

This guide explains how to verify the eShop deployment on OpenShift.

## 1. Automated Smoke Test
To verify all microservice endpoints in one go:
```bash
chmod +x openshift/test/smoke-test.sh
./openshift/test/smoke-test.sh
```
This script checks:
- HTTP availability of all Routes.
- Identity API OIDC configuration discovery.
- Catalog API data retrieval (v1.0).

## 2. End-to-End Manual Testing
Follow these steps in your browser:
1.  Navigate to `http://webapp-eshop.apps-crc.testing`.
2.  Click **Login** and use:
    - **User:** `bob`
    - **Pass:** `Pass123$`
3.  Add an item to the basket and complete the checkout.
4.  Verify order status in the "My Orders" section.

## 3. Configuration Best Practices
Ensure the `eshop-config` ConfigMap contains the following critical keys for Identity integration:
- `IdentityUrl`: Internal service URL for WebApp.
- `WebAppClient`: Public Route URL for OIDC redirection.
- `IdentityUrlExternal`: Public Route URL for browser-side redirects.

## 4. Troubleshooting
If the WebApp is not available:
- Check logs: `oc logs deployment/webapp -n eshop`
- Verify Route: `oc get route webapp -n eshop`
- Ensure `Identity.API` is running and the database is seeded.
