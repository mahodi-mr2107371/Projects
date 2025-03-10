"use client"

import { useEffect, useState } from "react";
import { redirect } from "next/navigation";
import { createPaper } from "@/app/utilities/actions";
import * as components from "@/app/components/common";
import * as subComponents from "@/app/components/submit-components";
import "@/public/styles/submit-paper.css";

export default function Home(){
    const [data, setData] = useState([]);
    const [isLoading, setLoading] = useState(false);
 
    let currentUser;
            if (localStorage.getItem("user")){
                currentUser = JSON.parse(localStorage.getItem("user"));
                console.log(currentUser);
            } 

    const [isValid, setValid] = useState(false);
    const [loaded, setLoaded] = useState(false);

    useEffect(() => {
        setLoading(true);
        fetch('http://localhost:3000/api/user/').then((res) => res.json()).then((data) => {
            setData(data);
            data.forEach((user, acc) => {
                if (user.email == currentUser && user.userRole == "Author"){
                    setValid(true);   
                }
                if (acc == data.length-1){
                    setLoaded(true);
                }
            });
            setLoading(false);
        });
    }, []);

    const [ids, setIds] = useState([]);

    const addAuthor = () => {
        setIds((currIds) => [...currIds, currIds.length + 1])
    }

    const removeAuthor = () => {
        setIds(ids.filter((id) => ids[ids.length-1] !== id));
    }

    if (isValid == false && loaded == true){
        redirect("/actions/return");
    }

    return(
        <main>
            <components.HeaderWithButtons />
            <div id="content">
                <h1 className={components.Styles.heading}>SUBMIT A PAPER</h1>
                <form id="paper-form" action={ createPaper } >
                    <label className={components.Styles.label} htmlFor="title">Title</label>
                    <input className={components.Styles.input} type="text" id="title" name="title" required />
                    <br/>
                    <label className={components.Styles.label} htmlFor="abstract">Abstract</label>
                    <textarea className={components.Styles.input} id="abstract" name="abstract" required></textarea>
                    <br/>
                    <div id="author-container">
                        <subComponents.AuthorFields id={0} />
                        {ids.map((id,acc)=>(
                            <subComponents.AuthorFields id={id} count={acc+2}/>
                        ))}      
                    </div>   
                    <hr className="border-4 border-slate-300 rounded"/>
                    <div id="buttons">
                        <button className={components.Styles.button}
                        type="button" id="add-author" onClick={addAuthor}>Add Author</button>

                        <button className={components.Styles.button} 
                        type="button" id="remove-author" onClick={removeAuthor}>Remove Author</button>
                    </div>
                    <br/>
                    <fieldset className={components.Styles.field} id="presenter">
                        <legend className={components.Styles.legend}>Presenter</legend>
                        <subComponents.PresenterButton id={1} showsChecked={true}/>
                        {ids.map((id, acc) => (
                            <subComponents.PresenterButton id={acc+2}/>
                        ))}
                    </fieldset>
                    <label className={components.Styles.label} htmlFor="file">Paper PDF</label>
                    <input className={components.Styles.input2} 
                    type="file" id="file" name="file" accept=".pdf" required />
                    <br/>
                    <input name="count" type="text" hidden value={(ids[ids.length-1] + 1).toString()} readOnly />
                    <div id="sub">
                        <input className={components.Styles.button} 
                        type="submit" value="Submit Paper" />
                    </div>  
                </form>
            </div>
        </main>
    )
}