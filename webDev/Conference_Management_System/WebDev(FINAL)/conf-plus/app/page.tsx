"use client"

import * as components from "./components/common";
import "../public/styles/login.css";
import Link from "next/link";
import { login } from "@/app/utilities/actions";

export default function Home() {

  return (
  <main>
      <components.Header />
      <div id="login">
        <h1 className={components.Styles.heading}>LOGIN</h1>
        <form id="login-form" action={ async (formData: FormData) => {
              const email = formData.get("email");
              console.log(email);
              localStorage.setItem("user", JSON.stringify(email));
              await login(formData);
              }}>
          <label className={components.Styles.label} htmlFor="email">Email</label>
          <input className={components.Styles.input} type="email" name="email" required />
          <br/>
          <label className={components.Styles.label} htmlFor="password">Password</label>
          <input className={components.Styles.input} type="password" name="password" required />
          <br/>
          <input type="submit" value="Login" className={components.Styles.button2} />
          <br/><br/>
          <p className={components.Styles.text}>Don't have an account?</p>
          <Link href="/actions/register">
          <button className={components.Styles.button2}>
            Register
          </button>
          </Link>
          <hr className="border-4 rounded border-slate-300"/>
          <Link href="/actions/display">
          <button className={components.Styles.button2}>
            Schedule
          </button>
          </Link>
          <Link href="/actions/stats">
          <button className={components.Styles.button2}>
            Stats
          </button>
          </Link>
        </form>
      </div>
  </main>
  )
}



