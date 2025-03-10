import { PrismaClient } from "@prisma/client";
import { getReviewerIDs } from "@/app/utilities/actions";
const prisma = new PrismaClient();

export async function readUsers(){   
    const users = await prisma.user.findMany();
    return users;
}

export async function readUserByEmail(userEmail){
    console.log(userEmail);
    const user = await prisma.user.findMany({
        where:{
            email: userEmail
        }
    })
    return user;
}

export async function readUsersByRole(role){
    const users = await prisma.user.findMany({
        where:{
            userRole: role
        }
    })

    return users;
}

export async function createUser(data){
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

export async function createPaper(data){
    const paperTitle = data.get("title");
    const paperAbstract = data.get("abstract");
    const paperScore = -1;
    let authors = [];

    const reviewers = await getReviewerIDs();
    let rev1, rev2;

    //grabbing the first reviewer randomly

    let rand = Math.floor(Math.random() * reviewers.length);
        rev1 = reviewers[rand];

    //grabbing a different second reviewer randomly
    while(true){
        rand = Math.floor(Math.random() * reviewers.length);
        rev2 = reviewers[rand];
        
        if (rev1 != rev2){
             break;
        }
    }

    const num = data.get("count");

    let count;

    if (num === "NaN"){
        count = 0;
    } else {
        count = Number(num) - 1;
    }

    const presenter = data.get("presenter");
    const presenterNum = Number(presenter);

    let iterator = -1;

    while (iterator != count){
        iterator++;
        const fname = data.get(`fname-${iterator}`);
        const lname = data.get(`lname-${iterator}`);
        const email = data.get(`email-${iterator}`);
        const affil = data.get(`affil-${iterator}`);

        let isPresenter = false;

        if (presenterNum == (iterator+1)){
        isPresenter = true;
        }

           authors.push({
               fname: fname,
               lname: lname,
               email: email,
               affil: affil,
               isPresenter: isPresenter
            })
       }


    const file = data.get("file");
    const size = file.size;
    const content = Buffer.from(await file.arrayBuffer());
    const fileName = file.name;
    const type = file.type;

    await prisma.paper.create({
        select:{
            title: true,
            abstract: true,
            score: true,
            fileName: true,
            size:true,
            file:true,
            type:true
        },
        data:{
            title: paperTitle,
            abstract: paperAbstract,
            score: paperScore,
            fileName: fileName,
            size: size,
            file:content,
            type:type
        }
    })

    await prisma.reviewPapers.create({
        data:{
            title: paperTitle,
            abstract: paperAbstract,
            id: rev1
        }
    })

    await prisma.reviewPapers.create({
        data:{
            title: paperTitle,
            abstract: paperAbstract,
            id: rev2
        }
    })

    authors.forEach(async (author) => {
        await prisma.paperAuthors.create({
            data:{
                title: paperTitle,
                abstract: paperAbstract,
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
    const papers = await prisma.paper.findMany();
    return papers;
}

export async function readReviewerPapers(revId){
    console.log(revId);

    const user = await prisma.user.findFirst({
        select:{
            id:true
        },
        where:{
            email: revId
        }
    })

    const papers = await prisma.paper.findMany({
        where:{

            reviwers:{

                some:{  

                    id: user.id

                    }

                },

            score: -1,
        },
        include:{
            authors: true
        }
    });

    console.log(papers);
    return papers;
}

export async function reviewPaper(title, abstract, formData){
    const overall = Number(formData.get("overall"));
    const contribution = Number(formData.get("contribution"));
    const strengths = formData.get("strengths");
    const weaknesses = formData.get("weaknesses");

    const updatedPaper = await prisma.paper.update({
        where:{
            title_abstract: {title, abstract}
        },
        data: {
            overall: overall,
            contributions: contribution,
            strengths: strengths,
            weaknesses: weaknesses,
            score:0
        }
    })
}

export async function readAcceptedPapers(){
    return await prisma.paper.findMany({
        where:{
            score:{
                gt: -1
            },
            overall:{
                gt: 1
            }
        }
    })
}

export async function readSessions(){
    return await prisma.session.findMany();
}

export async function createSession(formData){
    const title = formData.get("session-title");
    const paper = formData.get("paper");
    const abstract = formData.get("abstract");
    const location = formData.get("location");
    const date = formData.get("date");
    const ftime = formData.get("from-time");
    const ttime = formData.get("to-time");

    await prisma.session.create({
        data:{
            title:title,
            location:location,
            date:date,
            fromTime:ftime,
            toTime:ttime,
            acceptedTitle:paper,
            acceptedAbstract:abstract,
        }
    })
}   

export async function updateSession(formData){
    const title = formData.get("session");
    const location = formData.get("location");
    const date = formData.get("date");
    const ftime = formData.get("from-time");
    const ttime = formData.get("to-time");

    await prisma.session.update({
        where:{
            title: title
        },
        data:{
            location: location,
            date: date,
            fromTime: ftime,
            toTime: ttime
        }
    })
}

export async function deleteSession(title){
    await prisma.session.delete({
        where:{
            title:title,
        }
    })
}

export async function paperStatistics(){
    const totalPapers = await prisma.paper.aggregate({
        _count:{
            title:true
        }
    });
    const acceptedPapers = await prisma.paper.aggregate({
        _count:{
            title:true
        },
        where:{
            score:{
                gt: -1
            },
            overall:{
                gt: 1
            }
        }
    })
    const rejectedPapers = await prisma.paper.aggregate({
        _count:{
            title:true
        },
        where:{
            overall:{
                lt: 2
            }
        }
    })
    const authorsPerPaper = await prisma.paperAuthors.groupBy({
        by:["title"],
        _count:{
            email:true,
        }
    })

    let averageAuthors = 0;

    authorsPerPaper.forEach((paper, acc) => {
        averageAuthors+= paper._count.email;
        console.log(averageAuthors)
        if (acc == authorsPerPaper.length-1){
            averageAuthors = averageAuthors/(acc+1);
            console.log(averageAuthors);
        }
    })

    const totalSessions = await prisma.session.aggregate({
        _count:{
            title:true,
        }
    })

    const stats = {
        totalPapers: totalPapers,
        acceptedPapers: acceptedPapers,
        rejectedPapers: rejectedPapers,
        averageAuthors: averageAuthors,
        totalSessions: totalSessions
    }

    return stats;
}

export async function readInstitutions(){
    const institutions = await prisma.institution.findMany();
    return institutions;
}

export async function readLocations(){
    const locations = await prisma.location.findMany();
    return locations
}

export async function readDates(){
    return await prisma.date.findMany();
}