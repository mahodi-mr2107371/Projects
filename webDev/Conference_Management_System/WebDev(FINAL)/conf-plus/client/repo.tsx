"use client"

import Link from "next/link";
import * as components from "@/app/common";

export function loginForm ({ login }){
    return (
    <main>
        <components.Header />
        <div id="login">
        <h1>LOGIN</h1>
        <form id="login-form">
          <label htmlFor="email">Email</label>
          <input type="email" id="email" name="email" required />
          <br/>
          <label htmlFor="password">Password</label>
          <input type="password" id="password" name="password" required />
          <br/>
          <button type="submit" onClick={login}>Login</button>
          <br/><br/>
          <p>Don't have an account?</p>
          <Link href="/actions/register">
          <button id="register">
            Register
          </button>
          </Link>
        </form>
        </div>
    </main>
    )
}