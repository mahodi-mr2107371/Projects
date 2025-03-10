import * as repo from "../../../../utilities/repository.js"

export async function GET (request, {params}){
    const { role } = params; 
    const data = await repo.readUsersByRole(role);

    return Response.json(data, {status:200});
}