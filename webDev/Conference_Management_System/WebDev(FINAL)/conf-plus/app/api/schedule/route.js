import * as repo from "../../utilities/repository.js"

export async function GET (request){
    const data = await repo.readSessions();
    console.log(data);

    return Response.json(data, {status:200});
}

export async function POST (request){
    const data = await request.formData();

    await repo.createSession(data);
}
