require "net/http"
require "json"

class SendWhatsappMessageJob < ActiveJob::Base
  queue_as :default

  def perform(shopify_domain:, actions_id:, parameters: {})
    begin
      validate_parameters parameters

      uri = URI.parse("https://graph.facebook.com/v15.0/#{ENV["WA_PHONE_ID"]}/messages")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: parameters[:phone_number],
        type: "template",
        template: {
          name: ENV["WA_DISCOUNT_NOTIFICATION_TEMPLATE"],
          language: {
            code: "en"
          },
          components: [
            {
              type: "header",
              parameters: [
                {
                  "type": "image",
                  "image": {
                    "link": parameters[:image_url]
                  }
                }
              ]
            },
            {
              type: "body",
              parameters: [
                {
                  "type": "text",
                  "text": parameters[:product_name]
                },
                {
                  "type": "text",
                  "text": parameters[:discount_summary]
                }
              ]
            },
            {
              type: "button",
              sub_type: "url",
              index: "0",
              parameters: [
                {
                  type: "text",
                  text: "?actions_id=#{actions_id}"
                }
              ]
            }
          ]
        }
      }.to_json
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{ENV["WA_ACCESS_TOKEN"]}"
      response = http.request(request)

      logger.info "#{self.class} response:"
      logger.info response.body
    rescue => e
      logger.error("Error at #{self.class}.perform:")
      logger.error(e)
    end
  end

  def validate_parameters(parameters = {})
    required_keys = [
      :phone_number,
      :image_url,
      :product_name,
      :discount_summary
    ]

    required_keys.each do |rk|
      parameters[rk]

      if not parameters.has_key? rk
        raise StandardError.new "#{self.class}.perform error: Missing parameter #{rk}"
      end
    end
  end
end
