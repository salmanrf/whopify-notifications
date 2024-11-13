class DiscountsHelper
  def extract_customer_gets_product(discount)
    begin
      items = discount["customerGets"]["items"]

      products = []

      gets_type = items["__typename"]

      case gets_type
      when "DiscountProducts"
        products = extract_discount_products items
      when "DiscountCollections"
        products = extract_discount_collection_products items
      else
        []
      end

      products
    rescue StandardError => e
      puts ("Error at #{self.class}.extract_customer_gets_product:")
      puts (e)

      nil
    end
  end

  def extract_discount_products(items)
    products = {}

    product_variants = items["productVariants"]
    product = items["products"]

    if product_variants and product_variants["nodes"].is_a? Array
      product_variants["nodes"].each do |pv|
        products[pv["product"]["id"]] = pv["product"]
      end
    end

    if product and product["nodes"].is_a? Array
      product["nodes"].each do |product|
        products[product["id"]] = product
      end
    end

    products.values
  end

  def extract_discount_collection_products(items)
    products = {}

    collections = items["collections"]

    if collections and collections["nodes"].is_a? Array
      collections["nodes"].each do |coll|
        if coll["products"] and coll["products"]["nodes"].is_a? Array
          coll["products"]["nodes"].each do |product|
            products[product["id"]] = product
          end
        end
      end
    end

    products.values
  end

  def get_discount_summary(discount)
    if discount["__typename"].include? "Basic"
      return discount["shortSummary"]
    end

    if discount["__typename"].include? "Bxgy"
      return discount["summary"]
    end

    ""
  end
end
