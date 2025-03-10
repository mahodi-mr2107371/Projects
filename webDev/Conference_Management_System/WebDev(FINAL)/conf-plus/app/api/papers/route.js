import * as repo from "../../utilities/repository.ts"

export async function GET (request){
    const data = await repo.readPapers();
    console.log(data);

    return Response.json(data, {status:200});
}

export async function POST (request){
    const paper = await request.json();
    console.log(paper);

    await repo.createPaper(paper);    
}