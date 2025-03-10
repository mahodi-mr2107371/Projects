"use client"

import * as components from "@/app/components/common";
import * as manComps from "@/app/components/manage-components";
import "@/public/styles/manage-conference.css"
import { useState, useEffect } from "react";
import { redirect } from "next/navigation";
import Link from "next/link";
import { createSession } from "@/app/utilities/actions";


export default function Home(){

    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);

    let currentUser;
 
    if (typeof window !== 'undefined') {
        currentUser = JSON.parse(localStorage.getItem("user"));
    }  

    const [isValid, setValid] = useState(false);
    const [loaded, setLoaded] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch('http://localhost:3000/api/user/').then((res) => res.json()).then((data) => {
            setData(data);
            data.forEach((user, acc) => {
                if (user.email == currentUser && user.userRole == "Organizer"){
                    setValid(true);   
                }
                if (acc == data.length-1){
                    setLoaded(true);
                }
            });
            setLoading(false);
        });
    }, []);

    if (isValid == false && loaded == true){
        redirect("/actions/return");
    }

    return(
        <main>
            <components.HeaderWithButtons />
            <div id="content">

            <h2 className={components.Styles.heading}>Add Session</h2>
            <form id="session-form" action={createSession}>
            <label className={components.Styles.label} htmlFor="session-title">Title</label>
            <input className={components.Styles.input4} type="text" name="session-title" />
            <br/>

            <label className={components.Styles.label} htmlFor="paper">Paper</label>
            <manComps.PapersDropdown />
            <br/>

            <label className={components.Styles.label} htmlFor="location">Location</label>
            <manComps.LocationsDropdown />
            <br/>

            <label className={components.Styles.label} htmlFor="date">Date</label>
            <manComps.DatesDropdown />
            <br/>

            <label className={components.Styles.label} htmlFor="from-time">From</label>
            <input className={components.Styles.input4} type="text" name="from-time" placeholder="HH:MM" required />

            <label className={components.Styles.label} htmlFor="to-time">To</label>
            <input className={components.Styles.input4} type="text" name="to-time" placeholder="HH:MM" required />

            <br/>
            <div className="flex justify-center">
                <input type="submit" className={components.Styles.button2} value="Create Session" />  
                <Link className={components.Styles.button2} href="/actions/manage">Back</Link>          
            </div>
            </form>
            </div>
        </main>
    )
}