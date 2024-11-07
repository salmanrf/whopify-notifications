class CreateWebhookEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_events do |t|
      t.string :event_id, null: false
      t.string :topic, null: false
      t.timestamp :triggered_at, null: false
      t.jsonb :payload, null: false, default: "{}"

      t.timestamps
    end
  end
end
