
class CreateNotificationSubscriptions < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :notification_subscriptions, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :phone_number, null: false
      t.string :store_domain, null: false
      t.string :product_id, null: false
      t.boolean :notify_on_sales, null: true
      t.boolean :notify_on_available, null: true
      t.string :customer_first_name, null: true
      t.string :customer_last_name, null: true

      t.timestamps
    end
  end
end
