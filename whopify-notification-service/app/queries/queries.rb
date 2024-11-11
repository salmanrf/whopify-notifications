class Queries
  private
    def run_query(shopify_domain:, query:, variables:)
      shop = Shop.find_by(shopify_domain: shopify_domain)

      if not shop
        logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")

        raise ActiveRecord::RecordNotFound, "Shop Not Found"
      end

      shop.with_shopify_session do |session|
        client = ShopifyAPI::Clients::Graphql::Admin.new(
          session: session
        )

        response = client.query(query: query, variables: variables)

        response
      end
    end
end
