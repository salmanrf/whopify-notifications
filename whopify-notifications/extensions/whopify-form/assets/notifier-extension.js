class NotifierForm extends HTMLElement {
  api_url = "/apps/whopify-notifications/api";
  form = null;
  phone_number_input = null;
  product_available_input = null;
  discounted_input = null;
  store_domain_input = null;
  product_id_input = null;

  phoneTypingTimeoutId = null;

  storage_key = "whopify_notifications_subscriptions";
  subsriptionsList = [];

  constructor() {
    super();
  }

  connectedCallback() {
    this.form = this.querySelector("form");

    if (!this.form) {
      throw new Error("Can't find form element");
    }

    this.phone_number_input = this.querySelector('input[name="phone-number"]');
    this.store_domain_input = this.querySelector('input[name="store-domain"]');
    this.product_id_input = this.querySelector('input[name="product-id"]');
    this.product_available_input = this.querySelector("#when_product_available");
    this.discounted_input = this.querySelector("#when_discounted");

    this.form.onsubmit = this.onSubmitForm.bind(this);
    this.phone_number_input.onchange = this.onChangePhone.bind(this);

    this.loadSubscriptionData();
    this.refreshSubscriptionStatus();
  }

  loadSubscriptionData() {
    const subscriptions = localStorage.getItem(this.storage_key);

    try {
      const subscriptionsData = JSON.parse(subscriptions);

      if (!(subscriptionsData instanceof Array)) {
        this.subsriptionsList = [];
      } else {
        this.subsriptionsList = subscriptionsData;
      }
    } catch (error) {
      this.subsriptionsList = [];
    }
  }

  saveSubscriptionsToStorage() {
    localStorage.setItem(this.storage_key, JSON.stringify(this.subsriptionsList));
  }

  addProductToSubscriptionList(productId) {
    this.subsriptionsList.push(productId);
    this.saveSubscriptionsToStorage();
    this.refreshSubscriptionStatus();
  }

  refreshSubscriptionStatus() {
    const productId = (this.product_id_input ?? {}).value;

    if (this.subsriptionsList.includes(productId)) {
      this.form.innerHTML = '<div id="title">This item is on your watchlist!</div>';
    }
  }

  async onSubmitForm(e) {
    e.preventDefault();

    const phoneNumber = (this.phone_number_input.value + "").replace(/\D/g, "");

    if (!this.validatePhoneNumber(phoneNumber)) {
      return;
    }

    const productId = (this.product_id_input ?? {}).value;

    const data = {
      store_domain: this.store_domain_input.value,
      product_id: productId,
      phone_number: phoneNumber,
      notify_on_sales: !!(this.discounted_input ?? {}).checked,
      notify_on_available: !!(this.product_available_input ?? {}).checked,
    };

    try {
      const res = await fetch(`${this.api_url}/notification-subscriptions`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      });

      const body = await res.json();

      if (res.status !== 201) {
        throw new Error(body["errors"]);
      }

      this.addProductToSubscriptionList(productId);
    } catch (e) {
      console.log("Error at submit", e);
    }
  }

  onChangePhone(e) {
    const value = e.target.value.trim();

    if (this.phoneTypingTimeoutId) {
      clearTimeout(this.phoneTypingTimeoutId);
    }

    this.phoneTypingTimeoutId = setTimeout(() => {
      this.validatePhoneNumber(value);
    }, 250);
  }

  validatePhoneNumber(phoneNumber) {
    const errorContainers = this.querySelector(".form-error-messages");

    errorContainers.innerHTML = "";

    const isValid = (phoneNumber + "").match(
      /^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$/
    );

    if (!isValid) {
      const errorMessage = document.createElement("div");
      errorMessage.textContent = "Invalid phone number. Please enter a valid format.";
      errorMessage.classList.add("error-messages");

      errorContainers.appendChild(errorMessage);
    }

    return isValid;
  }
}

try {
  customElements.define("notifier-form", NotifierForm);
} catch (error) {
  console.error(error);
}
