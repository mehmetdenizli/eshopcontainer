# eShop OpenShift Manual Test Guide

Follow these steps to verify the full end-to-end flow of the application.

## 1. WebApp Accessibility
- Open [http://webapp-eshop.apps-crc.testing](http://webapp-eshop.apps-crc.testing) in your browser.
- You should see the catalog of items (loaded from `Catalog.API`).

## 2. Authentication Flow
- Click **Login** on the top right.
- You should be redirected to `identity-api-eshop.apps-crc.testing`.
- Use demo credentials (check `Identity.API` source or logs for default users).
- After login, you should be redirected back to the WebApp.

## 3. Basket Flow
- Add an item to the basket.
- This verifies connectivity between `WebApp` -> `Basket.API` -> `Redis`.

## 4. Checkout and Background Processing
- Go to the basket and click **Checkout**.
- Fill in the form and place the order.
- This verifies:
    - `Basket.API` -> `Ordering.API` communication.
    - `Ordering.API` -> `Postgres` persistence.
    - `Ordering.API` -> `RabbitMQ` message publishing.
    - `OrderProcessor` & `PaymentProcessor` consuming from RabbitMQ.

## 5. Verification
- Check the logs of `order-processor` to see if it processed your order:
  ```bash
  oc logs deployment/order-processor -n eshop
  ```
- Check the logs of `payment-processor` to see the payment simulation:
  ```bash
  oc logs deployment/payment-processor -n eshop
  ```
