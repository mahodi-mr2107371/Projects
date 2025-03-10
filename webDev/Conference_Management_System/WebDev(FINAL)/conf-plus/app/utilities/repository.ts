import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export async function readUsers(){
    const users = await prisma.user.findMany();
    return users;
}

export async function createUser(data: any){
    const userEmail = data.email;
    const userPass = data.password;
    const userRole = data.role;

    await prisma.user.create({
        select:{
            email: true,
            password: true,
            userRole: true
        },
        data:{
            email: userEmail,
            password: userPass,
            userRole: userRole
        }
    });
}

export async function createPaper(data: any){
    const paperTitle = data.title;
    const paperAbstract = data.abstract;
    const paperScore = data.score;
    const authors = data.authors
    const reviewer1 = data.rev1;
    const reviewer2 = data.rev2;
    const file = data.fileName;

    await prisma.paper.create({
        select:{
            title: true,
            abstract: true,
            score: true,
            fileName: true 
        },
        data:{
            title: paperTitle,
            abstract: paperAbstract,
            score: paperScore,
            fileName: file
        }
    })

    await prisma.reviewPapers.create({
        data:{
            title: paperTitle,
            id: reviewer1
        }
    })

    await prisma.reviewPapers.create({
        data:{
            title: paperTitle,
            id: reviewer2
        }
    })

    authors.forEach(async (author: { email: string; fname: string; lname: string; affil: string; isPresenter: boolean; }) => {
        await prisma.paperAuthors.create({
            data:{
                title: paperTitle,
                email: author.email,
                fname: author.fname,
                lname: author.lname,
                affil: author.affil,
                isPresenter: author.isPresenter
            }
        })
    })
}

export async function readPapers(){

}

export async function readInstitutions(){
    const institutions = await prisma.institution.findMany();
    return institutions;
}