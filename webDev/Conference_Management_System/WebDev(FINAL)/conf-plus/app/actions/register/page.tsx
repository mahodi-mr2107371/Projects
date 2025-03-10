"use client"

import * as components from "@/app/components/common";
import "@/public/styles/login.css";
import Link from "next/link";
import { register } from "@/app/utilities/actions";

export default function Home() {

    return(
        <main>
            <components.Header />
            <div id="login">
                <h1>REGISTER</h1>
                <form id="login-form" action={ register }>
                    <label className={components.Styles.label} htmlFor="email">Email</label>
                    <input className={components.Styles.input} type="email" name="email" required />
                    <br/>
                    <label className={components.Styles.label} htmlFor="password">Password</label>
                    <input className={components.Styles.input} type="password" name="password" required />
                    <label className={components.Styles.label} htmlFor="account-type">Role</label><br/>
                    <select name="account-type" className={components.Styles.input2}>
                        <option disabled selected value="">Select a Role</option>
                        <option value="Reviewer">Reviewer</option>
                        <option value="Author">Author</option>
                        <option value="Organizer">Organizer</option>
                    </select>
                    <br/>
                    <br/>
                    <br/>
                    <input className={components.Styles.button2} type="submit" value="Create"/>
                    <Link href="/">
                        <button className={components.Styles.button2}>Return</button>
                    </Link>
                </form>
            </div>
        </main>
    ) 
}