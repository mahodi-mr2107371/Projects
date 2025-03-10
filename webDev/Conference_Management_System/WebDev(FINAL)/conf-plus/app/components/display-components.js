"use client"

import * as components from "@/app/components/common";
import { useState, useEffect } from "react";

export function Schedule(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/schedule").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    return (
    <>
        {data.map((session) => (
            <div className={components.Styles.card}>
                <p className={components.Styles.text3}>{session.title}</p>
                <hr className="border-4 rounded border-slate-400"/>
                <p className={components.Styles.text2}>Location: {session.location}</p>
                <p className={components.Styles.text2}>Date: {session.date}</p>
                <p className={components.Styles.text2}>Timing: {session.fromTime}-{session.toTime}</p>    
            </div>
        ))}        
    </>
    )
}