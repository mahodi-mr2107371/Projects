"use client"

import * as components from "@/app/common"
import { useState, useEffect } from "react";

export function AuthorFields (props){

    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
 
    useEffect(() => {
        setLoading(true);
        fetch('http://localhost:3000/api/institutions').then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
      });
    }, []);

    if (isLoading) return <p>Loading...</p>;
    if (!data) return <p>Failed to load data.</p>;

    return (
        <div id={props.id}>
            <hr className="border-4 border-slate-300 rounded"/>
            <label className={components.Styles.label}>Author Details {props.count}</label>
            <label className={components.Styles.label2} htmlFor={"fname-" + props.id}>
                First Name
                <input className={components.Styles.input} name={"fname-" + props.id} key={"fname-" + props.id} type="text" required />
            </label>
            <label className={components.Styles.label2} htmlFor={"lname-" + props.id}>
                Last Name
                <input className={components.Styles.input} name={"lname-" + props.id} key={"lname-" + props.id} type="text" required />
            </label>
            <label className={components.Styles.label2} htmlFor={"email-" + props.id}>
                Email
                <input className={components.Styles.input} name={"email-" + props.id} key={"email-" + props.id} type="email" required />
            </label>
            <label className={components.Styles.label2} htmlFor={"affil-" + props.id}>
                Affiliation
                <br/>
                <select className={components.Styles.input} name={"affil-" + props.id} key={"affil-" + props.id}>
                    {data.map((inst, acc) =>(
                        <option value={inst.institution} key={acc}>{inst.institution}</option>
                    ))}
                </select>
            </label>
        </div>
    )
  }

  export function PresenterButton (props){
    return (
        <div id={props.id} className="flex">
            <label className={components.Styles.label3}>
                Author {props.id}
            </label>
            <input className="mb-5" type="radio" name="presenter" value={props.id} checked/>
        </div>
    )
  }