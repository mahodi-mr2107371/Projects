"use client"

import * as components from "@/app/components/common";
import * as disComponents from "@/app/components/display-components"
import "@/public/styles/display-schedule.css";

export default function Home(){

    return(
        <main>
            <components.HeaderWithButtons2 />
            
            <div id="schedule" className="my-4 pb-6 border-4 rounded-3xl border-purple-900">
                <h1 className={components.Styles.heading}>CONFERENCE SCHEDULE</h1>
                
         
                <div className="shadow-lg flex w-100 justify-center">
                    <disComponents.Schedule />
                </div>
            </div>

        </main>
    );
}