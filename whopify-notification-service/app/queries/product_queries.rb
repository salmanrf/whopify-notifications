class ProductQueries < Queries
  def find_product_by_id(shopify_domain:, product_id:, additional_fields: [])
    query =  <<~QUERY
      query ProductQueries($product_id: ID!) {
        product(id: $product_id) {
          __typename
          ...ProductSelect
        }
      }
      #{product_fragment additional_fields}
    QUERY

    variables = { product_id: product_id }

    res = run_query(shopify_domain: shopify_domain, query: query, variables: variables)

    res.body["data"]["product"]
  end

  def get_node_id(item_id)
    "gid://shopify/Product/#{item_id}"
  end

  def get_id_from_node_id(node_id)
    node_id.split("/").last
  end
end
