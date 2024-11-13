class Queries
  def product_fragment(additional_fields = [])
    fields = [
      "id",
      "title",
      "description",
      "onlineStoreUrl",
      "onlineStorePreviewUrl",
      "
      featuredMedia {
        preview {
          image {
            url
          }
        }
      }
      "
    ]

    additional_fields.each do |f|
      if not fields.include? f
        fields << f
      end
    end

    <<~QUERY
      fragment ProductSelect on Product {
        #{fields.join "\n"}
      }
    QUERY
  end

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
