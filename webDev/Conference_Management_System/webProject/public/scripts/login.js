document.querySelector("#login-form").addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = document.querySelector("#email").value;
  const password = document.querySelector("#password").value;

  const response = await fetch("/data/users.json");
  const users = await response.json();

  const user = users.find((user) => user.email === email && user.password === password);

  if (user) {
      onUserLogin(user.id);

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

function onUserLogin(userId) {
  localStorage.setItem("loggedInUserId", userId);
}
