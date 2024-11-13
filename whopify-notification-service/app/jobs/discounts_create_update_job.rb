class DiscountsCreateUpdateJob < ActiveJob::Base
  @@discount_queries = DiscountQueries.new
  @@discount_helper = DiscountsHelper.new

  def perform(shopify_domain:, payload:)
    begin
      gid = payload["admin_graphql_api_id"]

      discount = @@discount_queries.find_discount_by_id(shopify_domain:, discount_id: gid)

      if not discount
        raise StandardError.new "Discount #{gid} not found"
      end

      products = @@discount_helper.extract_customer_gets_product(discount)

      products.each do |product|
        HandleProductDiscountNotificationJob.perform_later(shopify_domain:, shopify_product: product, shopify_discount: discount)
      end

    rescue => e
      logger.error "Error at #{self.class}.perform:"
      logger.error e
    end
  end
end
