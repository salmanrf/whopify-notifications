class NotificationSubscriptionsApiController < ActionController::API
  include ApiResponsesHandler
  include ApiExceptionsHandler

  before_action :notification_subscription_params, :is_shop_registered?, only: %i[create]

  @@product_queries = ProductQueries.new

  def create
    begin
      product = @@product_queries.find_product_by_id(
        shopify_domain: @shop.shopify_domain,
        product_id: @@product_queries.get_node_id(@notification_subscription.product_id)
      )

      if not product
        return render_error_response([ "Product not found" ], 404)
      end

      existing = NotificationSubscription.find_by(phone_number: @notification_subscription.phone_number, product_id: @notification_subscription.product_id)

      if existing
        return render_success_response(status: 201, data: @notification_subscription)
      end

      saved = @notification_subscription.save

      if not saved
        return render_error_response([ "Internal system error", "error creating subscription" ], 500)
      end

      redirect_url = product["onlineStorePreviewUrl"]
      featured_image_url = ENV["WA_HEADER_IMAGE_PLACEHOLDER"]

      if product["featuredMedia"] and product["featuredMedia"]["preview"] and product["featuredMedia"]["preview"]["image"]
        featured_image_url = product["featuredMedia"]["preview"]["image"]["url"]
      end

      # ? Actions metadata (for unsubscribe and whatsapp links)
      metadata = {
        redirect_url:,
        featured_image_url:
      }

      @notification_subscription.create_subscription_action(metadata:)

      render_success_response(status: 201, data: @notification_subscription)
    rescue => e
      logger.error("Error at #{self.class}:")
      logger.error(e)

      render(status: 500, json: { status: :internal_system_error, json: { data: nil } })
    end
  end

  def unsubscribe
    begin
      action_id = params["action_id"]
      unsub_type = params["unsub_type"].to_s

      action = SubscriptionAction.find_by id: action_id

      if not action
        return render_error_response([ "Subscription action not found" ], 404)
      end

      subscription = action.notification_subscription

      if not subscription
        return render_error_response([ "Subscription not found" ], 404)
      end

      if unsub_type == "all"
        NotificationSubscription.destroy_by phone_number: subscription.phone_number
      else
        subscription.destroy
      end

      redirect_to "/unsubscribed"
    rescue => e
      logger.error("Error at #{self.class}.unsubscribe:")
      logger.error(e)

      render_error_response([ "Internal system error" ], 500)
    end
  end

  private
    def is_shop_registered?
      @shop = Shop.find_by shopify_domain: params["store_domain"]

      if not @shop
        render_error_response([ "Shop is not registered" ], 403)
      end
    end

    def notification_subscription_params
      filtered = params
        .require(:notification_subscriptions_api)
        .permit(
          :phone_number,
          :store_domain,
          :product_id,
          :notify_on_sales,
          :notify_on_available,
          :customer_first_name,
          :customer_last_name,
        )

      @notification_subscription = NotificationSubscription.new(filtered)

      if not @notification_subscription.valid?
        render_error_response(@notification_subscription.errors.full_messages.to_a, 400)
      end
    end
end
