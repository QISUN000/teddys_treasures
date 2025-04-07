// app/assets/javascripts/stripe.js
document.addEventListener('DOMContentLoaded', function() {
  const stripeForm = document.getElementById('payment-form');
  
  if (stripeForm) {
    // Initialize Stripe with your publishable key
    const stripe = Stripe(document.querySelector('meta[name="stripe-key"]').getAttribute('content'));
    const elements = stripe.elements();
    
    // Create and mount the Payment Element
    const cardElement = elements.create('card');
    cardElement.mount('#card-element');
    
    // Handle form submission
    stripeForm.addEventListener('submit', async function(event) {
      event.preventDefault();
      
      const submitButton = document.getElementById('submit-payment');
      submitButton.disabled = true;
      submitButton.textContent = 'Processing...';
      
      const errorElement = document.getElementById('card-errors');
      
      try {
        // Create payment method
        const result = await stripe.createPaymentMethod({
          type: 'card',
          card: cardElement,
          billing_details: {
            name: document.getElementById('cardholder-name').value,
            email: document.getElementById('cardholder-email').value
          },
        });
        
        if (result.error) {
          // Show error to your customer
          errorElement.textContent = result.error.message;
          submitButton.disabled = false;
          submitButton.textContent = 'Pay Now';
        } else {
          // Send payment method ID to server
          const paymentMethodId = result.paymentMethod.id;
          
          // Add the payment method ID to a hidden input field
          const hiddenInput = document.createElement('input');
          hiddenInput.setAttribute('type', 'hidden');
          hiddenInput.setAttribute('name', 'payment_method_id');
          hiddenInput.setAttribute('value', paymentMethodId);
          stripeForm.appendChild(hiddenInput);
          
          // Submit the form
          stripeForm.submit();
        }
      } catch (error) {
        console.error('Error:', error);
        errorElement.textContent = 'An unexpected error occurred. Please try again.';
        submitButton.disabled = false;
        submitButton.textContent = 'Pay Now';
      }
    });
  }
});