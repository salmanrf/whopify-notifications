class DiscountsCreateUpdateJob < ActiveJob::Base
  @@discount_queries = DiscountQueries.new

  def perform(shop_domain:, payload:)
    gid = payload["admin_graphql_api_id"]
    discount_type = @@discount_queries.get_discount_type_from_gid gid

    case discount_type
    when "DiscountAutomaticNode"
      handle_automatic_discount(shop_domain:, gid:)
    when "DiscountCodeNode"
      handle_code_discount(shop_domain:, gid:)
    end
  end

  def handle_automatic_discount(shop_domain:, gid:)
    discount = @@discount_queries.find_automatic_discount_by_id(shopify_domain: shop_domain, discount_id: gid)

    puts "DISCOUNT", discount
  end

  def handle_code_discount(shop_domain:, gid:)
  end
end
