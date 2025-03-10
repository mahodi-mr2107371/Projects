"use client"

import { useState,useEffect } from "react"
import { redirect } from "next/navigation"

export default function Home(){
    let currentUser;
    if(typeof window !== 'undefined'){currentUser = JSON.parse(localStorage.getItem("user"))}

    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);

    const [loaded, setLoaded] = useState(false);
    const [user, setUser] = useState();

    useEffect(() => {
        setLoading(true);
        fetch('http://localhost:3000/api/user/').then((res) => res.json()).then((data) => {
            setData(data);
            data.forEach((user, acc) => {
                if (user.email == currentUser){
                    setUser(user);
                }   
                if (acc == data.length-1){
                    setLoaded(true);
                }
            });
            setLoading(false);
        });
    }, []);    
        
    if(loaded && user)
    {
        switch (user.userRole){
        case "Author":
            redirect("/actions/submit");
        case "Reviewer":
            redirect("/actions/review");
        case "Organizer":
            redirect("/actions/manage");
    }}
    if (loaded && !user){
        redirect("/");
    }
}