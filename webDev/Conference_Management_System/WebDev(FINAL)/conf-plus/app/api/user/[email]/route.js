import * as repo from "../../../utilities/repository.js"

export async function GET (request, {params}){
    const { email } = params;
    console.log(email);
    const data = await repo.readUserByEmail(email);

    return Response.json(data, {status:200});
}