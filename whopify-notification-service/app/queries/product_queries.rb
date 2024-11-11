class ProductQueries < Queries
  def find_product_by_id(shopify_domain:, product_id:, fields: [ "id", "title", "description", "totalInventory" ])
    query =  <<~QUERY
      query ProductQueries($product_id: ID!) {
        product(id: $product_id) {
          __typename
          #{fields.join "\n"}
        }
      }
    QUERY

    variables = { product_id: product_id }

    res = run_query(shopify_domain: shopify_domain, query: query, variables: variables)

    res.body["data"]["product"]
  end

  def get_node_id(item_id)
    "gid://shopify/Product/#{item_id}"
  end
end
