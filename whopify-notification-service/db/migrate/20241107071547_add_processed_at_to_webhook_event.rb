class AddProcessedAtToWebhookEvent < ActiveRecord::Migration[7.2]
  def change
    add_column :webhook_events, :processed_at, :timestamp
  end
end
