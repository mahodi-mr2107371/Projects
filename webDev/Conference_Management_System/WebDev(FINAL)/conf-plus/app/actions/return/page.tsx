"use client"

import * as components from "@/app/components/common";
import "@/public/styles/login.css";
import Link from "next/link";

export default function Home() {
    return(
        <main>
            <components.Header />
            <div id="login">
                <p>
                    You are not authorized to access this webpage.
                </p>
                <p>
                    Please log in as an authorized user.
                </p>
                <br/><br/>
                <div className="flex justify-center">
                    <Link className={components.Styles.button2} href="/">
                        Return
                    </Link>
                </div>
            </div>
        </main>
    ) 
}