class WebhookEvent < ApplicationRecord
  def self.find_or_create(event_id:, topic:, triggered_at:, shop_domain:, payload:)
    event = WebhookEvent.find_by(event_id: event_id)

    if not event
      event = WebhookEvent.new(
        event_id: event_id,
        topic: topic,
        triggered_at: triggered_at,
        shop_domain: shop_domain,
        payload: payload
      )

      event.save
    end

    event
  end
end
