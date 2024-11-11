class AddMetadataToSubscriptionActions < ActiveRecord::Migration[7.2]
  def change
    add_column :subscription_actions, :metadata, :json, null: false
  end
end
