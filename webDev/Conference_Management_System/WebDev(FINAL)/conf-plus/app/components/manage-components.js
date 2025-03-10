"use client"

import * as components from "@/app/components/common";
import { useState, useEffect } from "react";

export function LocationsDropdown(){

    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/locations").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    return (
        <select className={components.Styles.input2} name="location">
            <option disabled selected value=""> Select an Available Venue </option>
            {data.map((loc) => (
                <option value={loc.location}> { loc.location } </option>
            ))}
        </select>
    )
}

export function DatesDropdown(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/dates").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    return (
        <select className={components.Styles.input2} name="date">
            <option disabled selected value=""> Select an Available Date </option>
            {data.map((date) => (
                <option value={date.date}> { date.date } </option>
            ))}
        </select>
    )
}

export function PapersDropdown(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
    const [abstract, setAbstract] = useState();
    const [paper, setPaper] = useState();

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/paper").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    function getDataForFields(selectedPaper){
        if(selectedPaper){
            setAbstract(data.filter((item)=>item.title == selectedPaper)[0].abstract);
        }
    }

    return (
        <select className={components.Styles.input2} value={paper} name="paper" onChange={e=> {
            setPaper(e.target.value);
            getDataForFields(e.target.value);
        }}>       
            <option disabled selected value=""> Select an Available Paper </option>
            {data.map((paper) => (
                <option value={paper.title}> { paper.title } </option>
            ))}
            <input hidden name="abstract" type="text" value={abstract} readOnly/> 
        </select>
        
    )
}

export function FormData(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
    const [location, setLocation] = useState();
    const [date, setDate] = useState();
    const [ftime, setFtime] = useState('HH:MM');
    const [ttime, setTtime] = useState('HH:MM');
    const [session, setSession] = useState('');

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/schedule").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;

    function getDataForFields(selectedSession){
        if(selectedSession){
            setLocation(data.filter((item)=>item.title == selectedSession)[0].location);
            setDate(data.filter((item)=>item.title == selectedSession)[0].date);
            setFtime(data.filter((item)=>item.title == selectedSession)[0].fromTime);
            setTtime(data.filter((item)=>item.title == selectedSession)[0].toTime);
        }
    }

    return (
        <>
        <label className={components.Styles.label} htmlFor="session-title">Session</label>
        <select className={components.Styles.input2} value={session} name="session" onChange={e=>{
            setSession(e.target.value);
            getDataForFields(e.target.value);
        }}>       
            <option disabled selected value=""> Select an Available Session </option>
            {data.map((session) => (
                <option value={session.title}> { session.title } </option>
            ))}
        </select>
        <br/>

        <label className={components.Styles.label} htmlFor="location">Location</label>
        {session !== '' ? <p className={components.Styles.text}>Current: {location}</p> : <></>}
        <LocationsDropdown />
        <br/>


        <label className={components.Styles.label} htmlFor="date">Date</label>
        {session !== '' ? <p className={components.Styles.text}>Current: {date}</p> : <></>}
        <DatesDropdown />
        <br/>

        <label className={components.Styles.label} htmlFor="from-time">From Time</label>
        <input className={components.Styles.input4} type="text" name="from-time" placeholder={ftime} required /> 
        <label className={components.Styles.label} htmlFor="to-time">To Time</label>
        <input className={components.Styles.input4} type="text" name="to-time" placeholder={ttime} required />
        </>
    )
}

export function SessionsDropdown(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
    const [location, setLocation] = useState();
    const [date, setDate] = useState();
    const [ftime, setFtime] = useState('HH:MM');
    const [ttime, setTtime] = useState('HH:MM');
    const [session, setSession] = useState('');

    useEffect(() => {
        setLoading(true);
        fetch("http://localhost:3000/api/schedule").then((res) => res.json()).then((data) => {
            setData(data);
            setLoading(false);
        })
    }, [])

    if (isLoading) return <p className={components.Styles.text}>Loading...</p>;
    if (!data) return <p className={components.Styles.text}>Failed to load data.</p>;    

    function getDataForFields(selectedSession){
        if(selectedSession){
            setLocation(data.filter((item)=>item.title == selectedSession)[0].location);
            setDate(data.filter((item)=>item.title == selectedSession)[0].date);
            setFtime(data.filter((item)=>item.title == selectedSession)[0].fromTime);
            setTtime(data.filter((item)=>item.title == selectedSession)[0].toTime);
        }
    }

    return(
        <>
        <label className={components.Styles.label} htmlFor="session-title">Session</label>
        <select className={components.Styles.input2} name="session" onChange={e=>{
            setSession(e.target.value);
            getDataForFields(e.target.value);
        }}>       
            <option disabled selected value=""> Select an Available Session </option>
            {data.map((session) => (
                <option value={session.title}> { session.title } </option>
            ))}
        </select>
        {session !== '' ? <p className={components.Styles.text}>Location: {location}</p> : <></>}
        {session !== '' ? <p className={components.Styles.text}>Date: {date}</p> : <></>}
        {session !== '' ? <p className={components.Styles.text}>Start Time: {ftime}</p> : <></>}
        {session !== '' ? <p className={components.Styles.text}>End Time: {ttime}</p> : <></>}
        </>
    )
}