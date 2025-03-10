"use server"

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";

async function getUsers () {
    
    const data = await fetch("http://localhost:3000/api/user");
    const users = await data.json();

    return users;
}

export async function getInstitutions () {
    const data = await fetch("http://localhost:3000/api/institutions");
    const institutions = await data.json();
    return institutions;
}

export async function getPapers (){
    const data = await fetch("http://localhost:3000/api/papers");
    const papers = await data.json();
    return papers;
}

export async function getReviewerIDs(){
    const users = await getUsers();
    console.log(users);
    let reviewerIDs:string[] = [];

    users.forEach((user:any)=>{
        if (user.userRole == "Reviewer"){
            reviewerIDs.push(user.id)
        } 
    });

    console.log(users);
    console.log(reviewerIDs);
    return reviewerIDs;
}

export async function login (formData: FormData){
    "use server";

    const email = formData.get("email");
    const password = formData.get("password");
    
    const users = await getUsers();

    console.log(users);

    const user = users.find((user: { email: string; password: string; }) => user.email == email && user.password == password);
    
    if (user) {
    console.log(user.userRole);
    switch (user.userRole) {
        case "Organizer":
            redirect("/actions/manage");
        case "Reviewer":
            redirect("/actions/review");
        case "Author":
            redirect("/actions/submit");
      }
  } else {
        console.log("Invalid login credentials");
  };
  }

export async function register(formData: FormData){
    "use server";

    const email = formData.get("email");

    const users = await getUsers();

    console.log(users);

    const exists = users.find((user: { email: string; }) => user.email == email);

    const password = formData.get("password");
    const userRole = formData.get("account-type");

    if (userRole == null){
        console.log("role is null");
        return;
      }
      if (exists) {
        console.log("account exists");
        return;
      } else {
        const user = {
            "email": email,
            "password": password,
            "role": userRole
        }  
        fetch("http://localhost:3000/api/user", {
        method:"POST",
        body: JSON.stringify(user),
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        }
      })
      revalidatePath("/");
      redirect("/");
      }
}

export async function createPaper(formData: FormData){
    "use server";

    fetch("http://localhost:3000/api/paper", {
    method:"POST",
    body: formData
    })
    redirect("/actions/submit");
    //alert("Your Paper has been successfully uploaded. Please wait for it to be reviewed.
}

export async function reviewPaper(formData: FormData){
    "use server";

    const revId = formData.get("paper");
    const abs = formData.get("abstract");

    fetch(`http://localhost:3000/api/paper/${revId}/${abs}`, {
        method:"POST",
        body: formData
        })
    redirect("/actions/review");
}

export async function createSession(formData: FormData){
    "use server";

    fetch('http://localhost:3000/api/schedule', {
        method:"POST",
        body: formData
        })
    redirect("/actions/manage");
}

export async function updateSession(formData: FormData){
    "use server";

    const title = formData.get("session");

    fetch(`http://localhost:3000/api/schedule/${title}`, {
        method:"POST",
        body: formData
        })
    redirect("/actions/manage");
}

export async function deleteSession(formData: FormData){
    "use server";

    const title = formData.get("session");

    fetch(`http://localhost:3000/api/schedule/${title}`, {
        method:"DELETE",
        body: formData
        })
    redirect("/actions/manage");
}
