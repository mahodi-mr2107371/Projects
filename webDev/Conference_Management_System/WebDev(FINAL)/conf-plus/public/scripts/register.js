document.querySelector("#account-type").selectedIndex = 0;
document.querySelector("#login-form").addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = document.querySelector("#email").value;
  const password = document.querySelector("#password").value;
  const type = document.querySelector("#account-type").value;

  const data = await fetch("http://localhost:3000/api/users");
  const users = await data.json();

  const exists = users.find((user) => user.email === email && user.password === password);

  if (type == ""){
    alert("Please select a role.");
    return;
  }
  if (exists) {
    alert("Account already exists. Please try logging in.");
    return;
  } else {
    const user = {
        "email": email,
        "password": password,
        "role": type
    }  
    fetch("http://localhost:3000/api/users", {
    method:"POST",
    body: JSON.stringify(user),
    headers: {
      "Content-type": "application/json; charset=UTF-8"
    }
  })
  alert("Account registered!");
  window.location.href = "login.html";
  }

  console.log(users);
});

document.querySelector("#return").addEventListener("click", ()=>{
    window.location.href="login.html";
})