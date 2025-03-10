"use server"

import { redirect } from "next/navigation"
import * as components from "@/app/SubmitComponents"

export async function getUsers () {
    const data = await fetch("http://localhost:3000/api/users");
    const users = await data.json();
    return users;
  }

export async function getInstitutions () {
    const data = await fetch("http://localhost:3000/api/institutions");
    const institutions = await data.json();
    return institutions;
}

export async function login (formData: { get: (arg0: string) => any; }){
    "use server";

    const email = formData.get("email");
    const password = formData.get("password");

    const users = await getUsers();

    console.log(users);

    const user = users.find((user: { email: any; password: any; }) => user.email === email && user.password === password);
    
    if (user) {
    console.log(user.role);
    switch (user.role) {
        case "organizer":
            redirect("/actions/manage");
        case "reviewer":
            redirect("/actions/review");
        case "author":
            redirect("/actions/submit");
      }
  } else {
        alert("Invalid login credentials.");
  };
  }

