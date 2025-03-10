"use client"

import * as components from "@/app/components/common";
import Link from "next/link";
import { useState, useEffect } from "react";

export function PaperDropdownAndDetails(){

    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
    const [paper, setPaper] = useState();
    const [abstract, setAbstract] = useState();
    const [authors, setAuthors] = useState([]);
    const [fileType, setFileType] = useState();

    let currentUser;

    if (typeof window !== 'undefined'){
        currentUser = JSON.parse(localStorage.getItem("user"));
    }

    useEffect(() => {
        setLoading(true);
        fetch(`http://localhost:3000/api/paper/${currentUser}`).then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
          })
    }, []);

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    function getDataForFields(selectedPaper){
        if(selectedPaper){
            setAbstract(data.filter((item)=>item.title == selectedPaper)[0].abstract);
            setAuthors(data.filter((item)=>item.title == selectedPaper)[0].authors);
            setFileType(data.filter((item)=>item.title == selectedPaper)[0].type);
        }
    }

    return (
        <>
        <select name="paper" className={components.Styles.input2} value={paper} onChange={e => {
            setPaper(e.target.value);
            getDataForFields(e.target.value);
            }}>
            <option disabled selected value=""> Select a Paper </option> 
            {data.map((paper) => (
                <option name={paper.title} value={paper.title}> {paper.title} </option>
            ))}
        </select>
        <input hidden name="paper" type="text" value={paper} readOnly/>        
        <br/>

        <label className={components.Styles.label} htmlFor="paper-authors">Authors</label>
        <div className={components.Styles.input3} name="paper-authors" readOnly>
            {authors.map((item, acc) => (
                <>
                <label htmlFor={item.fname}>
                    First Name
                </label>
                <p name={item.fname}>
                    {item.fname}
                </p>
                <label htmlFor={item.lname}>
                    Last Name
                </label>
                <p name={item.lname}>
                    {item.lname}
                </p>
                <label htmlFor={item.affil}>
                    Affiliation
                </label>
                <p name={item.affil}>
                    {item.affil}
                </p>
                <label htmlFor={item.email}>
                    Email
                </label>
                <p name={item.email}>
                    {item.email}
                </p>
                { acc < authors.length-1 ? <hr className="border-slate-300 border-2 rounded mt-4"/> : <></> }
                </>
            ))}
        </div>
        <br/>

        <label className={components.Styles.label} htmlFor="abstract">Abstract</label>
        <div className={components.Styles.input3} name="abstract" readOnly>
            { abstract }
            <input hidden name="abstract" type="text" value={abstract} readOnly/>
        </div>
        <div className="justify-center flex">
            <Link
                className={components.Styles.link}
                href={`/api/documents/${paper}`}
                download={paper}
                target="_blank"
            >
                Download
            </Link>
        </div>
        <br/>
        </>
    )
}


