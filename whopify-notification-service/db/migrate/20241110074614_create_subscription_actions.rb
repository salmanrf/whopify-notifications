class CreateSubscriptionActions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscription_actions, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :act_type
      t.belongs_to :notification_subscription, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
