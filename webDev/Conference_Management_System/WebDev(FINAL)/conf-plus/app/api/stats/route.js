import * as repo from "../../utilities/repository.js"

export async function GET (request){
    const data = await repo.paperStatistics();
    return Response.json(data, {status:200});
}
