"use client"

import * as components from "@/app/components/common";
import Link from "next/link";
import "@/public/styles/manage-conference.css";
import { useState, useEffect } from "react";
import { redirect } from "next/navigation";


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
            <div id="content" className="flex justify-evenly">
                <Link className={components.Styles.button}
                 href="/actions/manage/add">Add</Link>

                <Link className={components.Styles.button}
                 href="/actions/manage/update">Update</Link>

                <Link className={components.Styles.button}
                 href="/actions/manage/delete">Delete</Link>
            </div> 
        </main>
    )
}