class DiscountQueries < Queries
  def find_automatic_discount_by_id(shopify_domain:, discount_id:)
    query = <<~QUERY
      query DiscountQueries($discount_id: ID!) {
        discountNode(id: $discount_id) {
          discount {
            __typename
            ... on DiscountAutomaticBxgy {
              ...BasicAutoBxgySelect
            }
          }
        }
      }
      #{product_fragment}
      #{discount_collections_fragment}
      #{discount_products_fragment}
      #{discount_bxgy_fragment}
      #{customer_gets_fragment}
    QUERY

    puts "QUERY", query

    variables = { discount_id: }

    res = run_query(shopify_domain:, query:, variables:)

    puts "RES", res.body

    res.body["data"]["discountNode"]["discount"]
  end

  def find_code_discount_by_id(shopify_domain:, discount_id:)
    query = <<~QUERY
      query DiscountQueries($discount_id: ID!) {
        discountNode(id: $discount_id) {
          discount {
            __typename
            ... on DiscountAutomaticBxgy {
              ...BasicAutoBxgySelect
            }
          }
        }
      }
      #{product_fragment}
      #{discount_collections_fragment}
      #{discount_products_fragment}
      #{discount_bxgy_fragment}
      #{customer_gets_fragment}
    QUERY

    puts "QUERY", query

    variables = { discount_id: }

    res = run_query(shopify_domain:, query:, variables:)

    puts "RES", res.body

    res.body["data"]["discountNode"]["discount"]
  end

  def get_node_id(item_id)
    "gid://shopify/DiscountCodeNode/#{item_id}"
  end

  def get_discount_type_from_gid(item_id)
    (/Discount\w+/.match item_id || []).to_a.first
  end

  private
    def product_fragment
      <<~QUERY
        fragment ProductSelect on Product {
          id
          title
          description
          onlineStoreUrl
          onlineStorePreviewUrl
        }
      QUERY
    end

    def discount_collections_fragment
      <<~QUERY
        fragment DiscountCollectionsSellect on DiscountCollections {
          collections {
            nodes {
              products(first: 100) {
                nodes {
                  ...ProductSelect
                }
              }
            }
          }
        }
      QUERY
    end

    def discount_products_fragment
      <<~QUERY
        fragment DiscountProductsSelect on DiscountProducts {
          __typename
          productVariants(first: 100) {
            nodes {
              id
              title
              product {
                ...ProductSelect
              }
            }
          }
          products(first: 100) {
            nodes {
              ...ProductSelect
            }
          }
        }
      QUERY
    end

    def customer_gets_fragment
      <<~QUERY
        fragment CustomerGetItems on DiscountCustomerGets {
          items {
            __typename
            ... on DiscountCollections {
              ...DiscountCollectionsSellect
            }
            ... on DiscountProducts {
              ...DiscountProductsSelect
            }
          }
        }
      QUERY
    end

    def discount_bxgy_fragment
      <<~QUERY
        fragment BasicAutoBxgySelect on DiscountAutomaticBxgy {
          title
          summary
          status
          customerGets {
            ...CustomerGetItems
          }
        }
      QUERY
    end
end
