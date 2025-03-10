import * as repo from "../../../../utilities/repository.js"

export async function POST (request, { params }){
    const formData = await request.formData();
    const { revId } = params;
    const { abs } = params;

    console.log(revId)
    console.log(abs)
    await repo.reviewPaper(revId, abs, formData);

    return Response.json("Success.", {status:201});
}