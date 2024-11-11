class RemoveActTypeFromSubscriptionActions < ActiveRecord::Migration[7.2]
  def change
    remove_column :subscription_actions, :act_type, :string
  end
end
