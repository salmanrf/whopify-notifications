# frozen_string_literal: true

module Webhooks
  class CustomWebhooksController < ActionController::API
    include ShopifyApp::WebhookVerification

    def receive
      webhook_request = ShopifyAPI::Webhooks::Request.new(raw_body: request.raw_post, headers: request.headers.to_h)

      @event_topic = request.headers["X-Shopify-Topic"]
      @event_id = request.headers["X-Shopify-Event-Id"]
      @event_triggered_at = request.headers["X-Shopify-Triggered-At"]
      @event_payload = webhook_request.parsed_body

      event = WebhookEvent.find_or_create(
        event_id: @event_id,
        topic: @event_topic,
        triggered_at: @event_triggered_at,
        shop_domain: webhook_request.shop,
        payload: webhook_request.parsed_body
      )

      if event.processed_at
        return head(:no_content)
      end

      head(:no_content)
    end
  end
end
