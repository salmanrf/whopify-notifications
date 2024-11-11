require "test_helper"

class NotificationSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification_subscription = notification_subscriptions(:one)
  end

  test "should get index" do
    get notification_subscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_notification_subscription_url
    assert_response :success
  end

  test "should create notification_subscription" do
    assert_difference("NotificationSubscription.count") do
      post notification_subscriptions_url, params: { notification_subscription: { customer_first_name: @notification_subscription.customer_first_name, customer_last_name: @notification_subscription.customer_last_name, notify_on_available: @notification_subscription.notify_on_available, notify_on_sales: @notification_subscription.notify_on_sales, phone_number: @notification_subscription.phone_number, product_id: @notification_subscription.product_id, store_domain: @notification_subscription.store_domain } }
    end

    assert_redirected_to notification_subscription_url(NotificationSubscription.last)
  end

  test "should show notification_subscription" do
    get notification_subscription_url(@notification_subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_notification_subscription_url(@notification_subscription)
    assert_response :success
  end

  test "should update notification_subscription" do
    patch notification_subscription_url(@notification_subscription), params: { notification_subscription: { customer_first_name: @notification_subscription.customer_first_name, customer_last_name: @notification_subscription.customer_last_name, notify_on_available: @notification_subscription.notify_on_available, notify_on_sales: @notification_subscription.notify_on_sales, phone_number: @notification_subscription.phone_number, product_id: @notification_subscription.product_id, store_domain: @notification_subscription.store_domain } }
    assert_redirected_to notification_subscription_url(@notification_subscription)
  end

  test "should destroy notification_subscription" do
    assert_difference("NotificationSubscription.count", -1) do
      delete notification_subscription_url(@notification_subscription)
    end

    assert_redirected_to notification_subscriptions_url
  end
end
