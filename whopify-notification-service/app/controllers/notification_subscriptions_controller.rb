class NotificationSubscriptionsController < ApplicationController
  layout "notification_subscriptions"

  @@product_queries = ProductQueries.new

  def unsubscribe
    if not params["sub"]
      return head :not_found
    end

    @unsub_type = params["unsub_type"]
    @s_action = SubscriptionAction.find_by id: params["sub"]

    if not @s_action
      return head :not_found
    end

    @subscription = @s_action.notification_subscription

    if not @s_action or not @subscription
      head :not_found
    end

    product_id = @@product_queries.get_node_id @subscription.product_id
    @product = @@product_queries.find_product_by_id(
      shopify_domain: @subscription.store_domain,
      product_id: product_id
    )
  end

  def unsubscribed
  end
end
