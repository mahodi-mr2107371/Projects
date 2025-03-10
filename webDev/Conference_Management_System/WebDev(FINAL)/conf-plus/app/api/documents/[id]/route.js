import prisma from "@/app/api/prisma";

export async function GET (request, { params }){
    const { id } = params;

    console.log(id);

    const data = await prisma.paper.findFirst({
        where:{
            title: id,
        }
    })
    
    const blob = new Blob([data.file], {
        type: data.type,
    });

    return new Response(blob);
}