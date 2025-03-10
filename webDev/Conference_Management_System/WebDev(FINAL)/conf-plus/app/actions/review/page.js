"use client"

import * as components from "@/app/components/common";
import { useState, useEffect } from "react";
import { redirect } from "next/navigation";
import { reviewPaper } from "@/app/utilities/actions";
import * as revcomps from "@/app/components/review-components";
import "@/public/styles/review-paper.css";

export default function Home() {

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
                if (user.email == currentUser && user.userRole == "Reviewer"){
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

    return (
    <main>
        <components.HeaderWithButtons />
        <div id="form">
            <h1 className={components.Styles.heading}>REVIEW FORM</h1>
            <form id="review-form" className={components.Styles.form} action={reviewPaper}>

                <label className={components.Styles.label} htmlFor="paper-dropdown">Paper</label>
                
                <revcomps.PaperDropdownAndDetails />

                <label className={components.Styles.label} htmlFor="overall">Overall Evaluation</label>
                <select className={components.Styles.input4} name="overall">
                    <option disabled selected value="">Select an Evaluation Score.</option>
                    <option value="2">2: strong accept</option>
                    <option value="1">1: accept</option>
                    <option value="0">0: borderline</option>
                    <option value="-1">-1: reject</option>
                    <option value="-2">-2: strong reject</option>
                </select>
                <br/>

                <label className={components.Styles.label} htmlFor="contribution">Paper Contribution</label>
                <select className={components.Styles.input4} name="contribution">
                    <option disabled selected value="">Select a Contribution Score.</option>
                    <option value="5">5: a major and significant contribution</option>
                    <option value="4">4: a clear contribution</option>
                    <option value="3">3: minor contribution</option>
                    <option value="2">2: no obvious contribution</option>
                    <option value="1">1: no obvious contribution</option>
                </select>
                <br/>

                <label className={components.Styles.label} htmlFor="strengths">Paper Strengths</label>
                <textarea className={components.Styles.input4} name="strengths"></textarea>
                <br/>

                <label className={components.Styles.label} htmlFor="weaknesses">Paper Weaknesses</label>
                <textarea className={components.Styles.input4} name="weaknesses"></textarea>
                <br/>

                <div className="justify-center flex">
                    <input type="submit" value="Submit Review" className={components.Styles.button2}/>
                </div>
            </form>
        </div>
    </main>
  )
}



