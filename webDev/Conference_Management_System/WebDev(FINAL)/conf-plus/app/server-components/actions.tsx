"use server"

import { getInstitutions } from "../actions";
import * as subComponents from "@/app/SubmitComponents"

export async function addAuthorFields (id: number){
    "use server"

    const instData = await getInstitutions();
    let institutions: string[] = [];

    instData.forEach((data: any)=>{
        institutions.push(data.institution);
    });

    return <subComponents.AuthorFields id={id} inst={institutions} />
}