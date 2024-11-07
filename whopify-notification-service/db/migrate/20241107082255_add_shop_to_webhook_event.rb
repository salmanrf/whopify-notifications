class AddShopToWebhookEvent < ActiveRecord::Migration[7.2]
  def change
    add_column :webhook_events, :shop_domain, :string, null: false
  end
end
