import * as repo from "../../../utilities/repository.js"

export async function GET (request, { params }){
    const { revId } = params;
    console.log(revId);
    const data = await repo.readReviewerPapers(revId);
    console.log(data);

    return Response.json(data, {status:200});
}