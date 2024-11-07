class DiscountsCreateUpdateJob < ActiveJob::Base
  def perform(shop_domain:, payload:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    if shop.nil?
      logger.error("#{self.class} failed: cannot find shop with domain '#{shop_domain}'")

      raise ActiveRecord::RecordNotFound, "Shop Not Found"
    end

    shop.with_shopify_session do |session|
      client = ShopifyAPI::Clients::Graphql::Admin.new(
        session: session
      )

      query = <<~QUERY
        {
          codeDiscountNode(id: "gid://shopify/DiscountCodeNode/1231778807977") {
            id
            codeDiscount {
              __typename
              ... on DiscountCodeBxgy {
                title
                customerBuys {
                  items {
                    __typename
                  }
                  value {
                    __typename
                    ... on DiscountQuantity {
                      quantity
                    }
                    ... on DiscountPurchaseAmount {
                      amount
                    }
                  }
                }
              }
              ... on DiscountCodeBasic {
                title
              }
            }
          }
        }
      QUERY

      response = client.query(query: query)

      puts "response", response.body["data"]
    end
  end
end
