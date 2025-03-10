"use client"

import * as components from "@/app/components/common";
import { useState, useEffect } from "react";
import "@/public/styles/review-paper.css";

export default function Home() {

    const [data, setData] = useState();
    const [isLoading, setLoading] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch('http://localhost:3000/api/stats').then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        });
    }, []);

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    console.log(data);

    return (
    <main>
        <components.HeaderWithButtons3 />
        <div id="form">
            <h1 className={components.Styles.heading}>STATISTICS</h1>
            <form id="review-form" className={components.Styles.form}>

                <label className={components.Styles.label} htmlFor="total">Total</label>

                {data.totalPapers._count.title > 1 ? 
                <p className={components.Styles.input5} name="total">
                    {data.totalPapers._count.title} Papers
                </p> : (data.totalPapers._count.title == 1 ? 
                <p className={components.Styles.input5} name="total">
                {data.totalPapers._count.title} Paper
                </p> : <p className={components.Styles.input5} name="total">
                       None
                </p>
                )}

                <br/>

                <label className={components.Styles.label} htmlFor="accepted">Accepted</label>
                {data.acceptedPapers._count.title > 1 ? 
                <p className={components.Styles.input5} name="accepted">
                    {data.acceptedPapers._count.title} Papers
                </p> : (data.acceptedPapers._count.title == 1 ? 
                <p className={components.Styles.input5} name="accepted">
                {data.acceptedPapers._count.title} Paper
                </p> : <p className={components.Styles.input5} name="accepted">
                       None
                </p>
                )}

                <br/>

                <label className={components.Styles.label} htmlFor="rejected">Rejected</label>
                {data.rejectedPapers._count.title > 1 ? 
                <p className={components.Styles.input5} name="rejected">
                    {data.rejectedPapers._count.title} Papers
                </p> : (data.rejectedPapers._count.title == 1 ? 
                <p className={components.Styles.input5} name="rejected">
                {data.rejectedPapers._count.title} Paper
                </p> : <p className={components.Styles.input5} name="rejected">
                       None
                </p>
                )}

                <br/>

                <label className={components.Styles.label} htmlFor="average">Avg. Authors Per Paper</label>
                {data.averageAuthors > 1 ? 
                <p className={components.Styles.input5} name="average">
                    {data.averageAuthors} Authors
                </p> : (data.averageAuthors == 1 ? 
                <p className={components.Styles.input5} name="average">
                {data.averageAuthors} Author
                </p> : <p className={components.Styles.input5} name="average">
                       None
                </p>
                )}
                <br/>

                <label className={components.Styles.label} htmlFor="total-sessions">Total Sessions</label>
                {data.totalSessions._count.title > 1 ? 
                <p className={components.Styles.input5} name="total-sessions">
                    {data.totalSessions._count.title} Sessions
                </p> : (data.totalSessions._count.title == 1 ? 
                <p className={components.Styles.input5} name="total-sessions">
                {data.totalSessions._count.title} Session
                </p> : <p className={components.Styles.input5} name="total-sessions">
                       None
                </p>
                )}
                <br/>

            </form>
        </div>
    </main>
  )
}