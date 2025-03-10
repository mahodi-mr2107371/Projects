// Get the form element and add an event listener to it
const loginForm = document.getElementById('login-form');
loginForm.addEventListener('submit', loginUser);

// Define the loginUser function
function loginUser(event) {
  // Prevent the default form submission behavior
  event.preventDefault();

  // Get the email and password input fields from the form
  const emailInput = document.getElementById('email');
  const passwordInput = document.getElementById('password');

  // Get the user data from the users.json file using fetch()
  fetch('users.json')
    .then(response => response.json())
    .then(users => {
      // Check if there is a user with the given email and password
      const currentUser = users.find(user => user.email === emailInput.value && user.password === passwordInput.value);

      // If there is a user, redirect to the dashboard page
      if (currentUser) {
        window.location.href = './dashboard.html';
      } else {
        // If there is no user, display an error message
        alert('Invalid email or password. Please try again.');
      }
    })
    .catch(error => console.error('Error fetching user data:', error));
}
