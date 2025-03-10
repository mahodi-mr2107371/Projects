import * as components from "@/app/common";
import "@/public/styles/review-paper.css";

export default async function Home() {
  return (
  <main>
        <components.HeaderWithButtons link1="/actions/display" link2="/" />
        <div id="assigned-papers">
            <h1>ASSIGNED PAPERS</h1>
        </div>

        <div id="form">
            <h1>REVIEW FORM</h1>
            <form id="review-form">
                <label htmlFor="paper-dropdown">Paper</label>
                
                <select id="paper-dropdown">
                </select>
                <br/>

                <label htmlFor="paper-title">Title</label>
                <input type="text" id="paper-title" readOnly />
                <br/>

                <label htmlFor="paper-authors">Authors</label>
                <input type="text" id="paper-authors" readOnly />
                <br/>

                <label htmlFor="paper-abstract">Abstract</label>
                <textarea id="paper-abstract" readOnly></textarea>
                <br/>

                <label htmlFor="overall-evaluation">Overall Evaluation</label>
                <select id="overall-evaluation">
                    <option value="2">2: strong accept</option>
                    <option value="1">1: accept</option>
                    <option value="0">0: borderline</option>
                    <option value="-1">-1: reject</option>
                    <option value="-2">-2: strong reject</option>
                </select>
                <br/>

                <label htmlFor="paper-contribution">Paper Contribution</label>
                <select id="paper-contribution">
                    <option value="5">5: a major and significant contribution</option>
                    <option value="4">4: a clear contribution</option>
                    <option value="3">3: minor contribution</option>
                    <option value="2">2: no obvious contribution</option>
                    <option value="1">1: no obvious contribution</option>
                </select>
                <br/>

                <label htmlFor="paper-strengths">Paper Strengths</label>
                <textarea id="paper-strengths"></textarea>
                <br/>

                <label htmlFor="paper-weaknesses">Paper Weaknesses</label>
                <textarea id="paper-weaknesses"></textarea>
                <br/>

                <button type="submit">Submit Review</button>
            </form>
        </div>
    </main>
  )
}



