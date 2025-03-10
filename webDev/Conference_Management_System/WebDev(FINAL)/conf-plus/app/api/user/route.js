import * as repo from "../../utilities/repository.js"

export async function GET (request){
    const data = await repo.readUsers();

    return Response.json(data, {status:200});
}

export async function POST (request){
    try{
        const user = await request.json();
        await repo.createUser(user);

        return Response.json({message:'Registered', status:201});
    }
    catch(error){
        console.error(error.message);
        return Response.json({message: "Internal server error occurred."}, {status: 500});
    }
    
}