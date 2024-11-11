class SubscriptionAction < ApplicationRecord
  belongs_to :notification_subscription

  validates :act_type, inclusion: { in: %w[unsubscribe], message: "Invalid subscription_action.type %{value}" }
end
