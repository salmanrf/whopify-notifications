class HandleProductDiscountNotificationJob < ApplicationJob
  @@product_queries = ProductQueries.new
  @@discount_helper = DiscountsHelper.new

  queue_as :default

  def perform(shopify_domain:, shopify_discount:, shopify_product:)
    begin
      notification_subs = NotificationSubscription.where(
        notify_on_sales: true,
        product_id: @@product_queries.get_id_from_node_id(shopify_product["id"])
      )

      if notification_subs.length == 0
        logger.info "No subscription found"

        return
      end

      notification_subs.each do |ns|
        actions = ns.subscription_action
        actions_id = actions.id

        discount_summary = @@discount_helper.get_discount_summary shopify_discount
        product_name = shopify_product["title"]
        phone_number = ns.phone_number
        image_url = actions.metadata["featured_image_url"]

        parameters = {
          discount_summary:,
          product_name:,
          phone_number:,
          image_url:
        }

        SendWhatsappMessageJob.perform_later(
          shopify_domain:,
          actions_id:,
          parameters:,
        )
      end

    rescue => e
      logger.error "Error at #{self.class}.perform:"
      logger.error e
    end
  end
end
