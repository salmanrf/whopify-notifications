class NotificationSubscription < ApplicationRecord
  has_one :subscription_action, dependent: :destroy

  validates :phone_number, presence: true

  validates :store_domain, presence: true

  validates :product_id, presence: true

  validates :notify_on_sales, presence: false

  validates :notify_on_available, presence: false

  validates :customer_first_name, presence: false

  validates :customer_last_name, presence: false
end
