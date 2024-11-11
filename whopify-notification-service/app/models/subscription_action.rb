class SubscriptionAction < ApplicationRecord
  belongs_to :notification_subscription

  validates :metadata, presence: true
end
