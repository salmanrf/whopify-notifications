# Whopify Notifications 🛍️

Whopify enables customers to create a wishlist and receive personalized notifications directly on WhatsApp for product updates, restocks, and special offers. Customers are in control of their notification preferences and can manage or unsubscribe from specific product notifications anytime they like.

# Apps

## Whopify Theme App Extension

This is theme app extension app block that serves as the notification subscription form.

```
/whopify-notifications
```

## Whopify Notifications Service

The Back-end service for Whopify Notifications. This service serves subscription APIs, handle Shopify Webhooks and send Whatsapp notification messages.

```
/whopify-notifications
```

# Running Locally

**Theme app extension**

```
$ shopify app dev
```

**Back-end Service**

```
$ rails server -e development
```
