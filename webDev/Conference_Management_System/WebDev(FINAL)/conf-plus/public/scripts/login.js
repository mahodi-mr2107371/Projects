localStorage.removeItem("currentUser");

document.querySelector("#login-form").addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = document.querySelector("#email").value;
  const password = document.querySelector("#password").value;

  const data = await fetch("http://localhost:3000/api/users");
  const users = await data.json();

  console.log(users);

  const user = users.find((user) => user.email === email && user.password === password);

  if (user) {
      onUserLogin(user);
      console.log(user);
   
      switch (user.role) {
          case "organizer":
              window.location.href = "manage-conference.html";
              break;
          case "reviewer":
              window.location.href = "review-paper.html";
              break;
          case "author":
              window.location.href = "submit-paper.html";
              break;
      }
  } else {
      alert("Invalid email or password.");
  }
});

document.querySelector("#register").addEventListener("click", ()=>{
    window.location.href="register.html";
})

function onUserLogin(user) {
  localStorage.setItem("currentUser", JSON.stringify(user));
  console.log(user);
}
