import * as repo from "../../../utilities/repository.js"

export async function POST (request){
    const data = await request.formData();
    await repo.updateSession(data);

    return Response.json(data, {status:201});
}

export async function DELETE (request, { params }){
    const { title } = params;

    await repo.deleteSession(title);
}
