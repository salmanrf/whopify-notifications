class DiscountQueries < Queries
  def find_discount_by_id(shopify_domain:, discount_id:)
    begin
      discount_type = get_discount_type_from_gid discount_id

      case discount_type
      when "DiscountAutomaticNode"
        find_automatic_discount_by_id shopify_domain:, discount_id:
      when "DiscountCodeNode"
        find_code_discount_by_id shopify_domain:, discount_id:
      end
    rescue => e
      logger.error("Error at #{self.class}.find_discount_by_id:")
      logger.error(e)

      raise e
    end
  end

  def find_automatic_discount_by_id(shopify_domain:, discount_id:)
    query = <<~QUERY
      query DiscountQueries($discount_id: ID!) {
        discountNode(id: $discount_id) {
          discount {
            __typename
            ...AutoDiscountSelect
          }
        }
      }
      #{discount_auto_fragment}
    QUERY

    variables = { discount_id: }

    res = run_query(shopify_domain:, query:, variables:)

    if not res.body["data"] or not res.body["data"]["discountNode"]
      return nil
    end

    (res.body["data"]["discountNode"] or {})["discount"]
  end

  def find_code_discount_by_id(shopify_domain:, discount_id:)
    query = <<~QUERY
      query DiscountQueries($discount_id: ID!) {
        discountNode(id: $discount_id) {
          discount {
            __typename
            ...CodeDiscountSelect
          }
        }
      }
      #{discount_code_fragment}
    QUERY

    variables = { discount_id: }

    res = run_query(shopify_domain:, query:, variables:)

    if not res.body["data"] or not res.body["data"]["discountNode"]
      return nil
    end

    (res.body["data"]["discountNode"] or {})["discount"]
  end

  def get_node_id(item_id)
    "gid://shopify/DiscountCodeNode/#{item_id}"
  end

  def get_discount_type_from_gid(item_id)
    (/Discount\w+/.match item_id || []).to_a.first
  end

  private
    def discount_collections_fragment
      <<~QUERY
        fragment DiscountCollectionsSelect on DiscountCollections {
          collections(first: 100) {
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
              ...DiscountCollectionsSelect
            }
            ... on DiscountProducts {
              ...DiscountProductsSelect
            }
          }
        }
      QUERY
    end

    def discount_auto_fragment
      <<~QUERY
        #{product_fragment}
        #{discount_collections_fragment}
        #{discount_products_fragment}
        #{customer_gets_fragment}
        fragment AutoDiscountSelect on Discount {
          ... on DiscountAutomaticBxgy {
            title
            summary
            status
            customerGets {
              ...CustomerGetItems
            }
          }
          ... on DiscountAutomaticBasic {
            title
            shortSummary
            status
            customerGets {
              ...CustomerGetItems
            }
          }
        }
      QUERY
    end

    def discount_code_fragment
      <<~QUERY
        #{product_fragment}
        #{discount_collections_fragment}
        #{discount_products_fragment}
        #{customer_gets_fragment}
        fragment CodeDiscountSelect on Discount {
          ... on DiscountCodeBxgy {
            title
            summary
            status
            customerGets {
              ...CustomerGetItems
            }
          }
          ... on DiscountCodeBasic {
            title
            shortSummary
            status
            customerGets {
              ...CustomerGetItems
            }
          }
        }
      QUERY
    end
end
