require "application_system_test_case"

class NotificationSubscriptionsTest < ApplicationSystemTestCase
  setup do
    @notification_subscription = notification_subscriptions(:one)
  end

  test "visiting the index" do
    visit notification_subscriptions_url
    assert_selector "h1", text: "Notification subscriptions"
  end

  test "should create notification subscription" do
    visit notification_subscriptions_url
    click_on "New notification subscription"

    fill_in "Customer first name", with: @notification_subscription.customer_first_name
    fill_in "Customer last name", with: @notification_subscription.customer_last_name
    check "Notify on available" if @notification_subscription.notify_on_available
    check "Notify on sales" if @notification_subscription.notify_on_sales
    fill_in "Phone number", with: @notification_subscription.phone_number
    fill_in "Product", with: @notification_subscription.product_id
    fill_in "Store domain", with: @notification_subscription.store_domain
    click_on "Create Notification subscription"

    assert_text "Notification subscription was successfully created"
    click_on "Back"
  end

  test "should update Notification subscription" do
    visit notification_subscription_url(@notification_subscription)
    click_on "Edit this notification subscription", match: :first

    fill_in "Customer first name", with: @notification_subscription.customer_first_name
    fill_in "Customer last name", with: @notification_subscription.customer_last_name
    check "Notify on available" if @notification_subscription.notify_on_available
    check "Notify on sales" if @notification_subscription.notify_on_sales
    fill_in "Phone number", with: @notification_subscription.phone_number
    fill_in "Product", with: @notification_subscription.product_id
    fill_in "Store domain", with: @notification_subscription.store_domain
    click_on "Update Notification subscription"

    assert_text "Notification subscription was successfully updated"
    click_on "Back"
  end

  test "should destroy Notification subscription" do
    visit notification_subscription_url(@notification_subscription)
    click_on "Destroy this notification subscription", match: :first

    assert_text "Notification subscription was successfully destroyed"
  end
end
