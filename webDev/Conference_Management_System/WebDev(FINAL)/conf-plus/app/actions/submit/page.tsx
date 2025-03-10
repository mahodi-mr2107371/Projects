import * as components from "@/app/common";
import * as subComponents from "@/app/server-components/actions";
import "@/public/styles/submit-paper.css";

export default function Home(){

    return(
        <main>
            <components.HeaderWithButtons link1="/actions/display" link2="/" />
            <div id="content">
                <h1>SUBMIT A PAPER</h1>
                <form id="paper-form" className="flex-col justify-center">
                    <label htmlFor="title">Title</label>
                    <input className={components.Styles.input} type="text" id="title" name="title" required />
                    <br/>
                    <label htmlFor="abstract">Abstract</label>
                    <textarea className={components.Styles.input} id="abstract" name="abstract" required></textarea>
                    <br/>
                    <div id="author-container">
                        {subComponents.addAuthorFields(1)}
                    </div>   
                    <div id="buttons">
                        <button type="button" id="add-author">Add Author</button>
                    </div>
                    <br/>
                    <fieldset id="presenter">
                        
                    </fieldset>
                    <label htmlFor="file">Paper PDF</label>
                    <input type="file" id="file" name="file" accept=".pdf" required />
                    <br/>
                    <div id="sub">
                        <button type="submit" id="submit-btn">Submit Paper</button>
                        <button type="button" id="test">Test Functions!</button>
                    </div>  
                </form>
            </div>
        </main>
    )
}