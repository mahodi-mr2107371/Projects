
import UserRepository from '../repositories/userRepository.js';

document.querySelector("#login-form").addEventListener("submit", async (event) => {
  event.preventDefault();
  
  const email = document.querySelector("#email").value;
  const password = document.querySelector("#password").value;
  
  const userRepository = new UserRepository();


  const user = await userRepository.findUserByEmail(email);

  if (user && user.password === password) {
    switch (user.role) {
      case "organizer":
        window.location.href = "/templates/manage-conference.html";
        break;
      case "reviewer":
        window.location.href = "/templates/review-paper.html";
        break;
      case "author":
        window.location.href = "/templates/submit-paper.html";
        break;
    }
  } else {
    alert("Invalid email or password.");
  }
});
