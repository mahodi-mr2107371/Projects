import * as repo from "../../utilities/repository.js"

export async function GET (request){
    const data = await repo.readAcceptedPapers();

    return Response.json(data, {status:200});
}

export async function POST (request){
    const data = await request.formData();
    console.log(data);

    await repo.createPaper(data);    
}