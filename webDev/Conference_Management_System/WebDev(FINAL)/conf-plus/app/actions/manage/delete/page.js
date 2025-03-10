"use client"

import * as components from "@/app/components/common";
import * as manComps from "@/app/components/manage-components";
import "@/public/styles/manage-conference.css"
import { useState, useEffect } from "react";
import { redirect } from "next/navigation";
import Link from "next/link";
import { deleteSession } from "@/app/utilities/actions";


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

            <h2 className={components.Styles.heading}>Delete Session</h2>
            <form id="session-form" action={ deleteSession }>

            <manComps.SessionsDropdown />    

            <br/>

            <div className="flex justify-center">
                <input type="submit" className={components.Styles.button2} value="Delete Session" /> 
                <Link className={components.Styles.button2} href="/actions/manage">Back</Link>           
            </div>
            </form>
            </div>
        </main>
    )
}