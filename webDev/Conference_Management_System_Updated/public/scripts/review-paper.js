let assignedPapers = [];

async function loadAssignedPapers() {
    const loggedInUserId = parseInt(localStorage.getItem("loggedInUserId"));
    const papers = await fetch("/data/papers.json").then((res) => res.json());

    assignedPapers = papers.filter((paper) =>
        paper.reviewers.some((reviewerId) => reviewerId === loggedInUserId)
    );

    //displayAssignedPapers(assignedPapers);
    populatePaperDropdown(assignedPapers);
}


async function displayAssignedPapers(assignedPapers) {
    const assignedPapersContainer = document.getElementById("assigned-papers");
    console.log(assignedPapers);
    assignedPapers.forEach((paper) => {
        const paperElement = document.createElement("div");
        paperElement.textContent = paper.title;
        assignedPapersContainer.appendChild(paperElement);
        console.log("displayed a paper");
    });
}

function populatePaperDropdown(assignedPapers) {
    const paperDropdown = document.getElementById("paper-dropdown");

    assignedPapers.forEach((paper) => {
        console.log("Adding option for paper:", paper); // Add this line
        const option = document.createElement("option");
        option.value = paper.id;
        option.textContent = `${paper.id}: ${paper.title}`;
        paperDropdown.appendChild(option);
    });
}




async function init() {
    document.addEventListener("DOMContentLoaded", async () => {
        await loadAssignedPapers();
        if (assignedPapers.length > 0) {
            updateFormFields(assignedPapers[0]);
        }
    });
    document.getElementById("paper-dropdown").addEventListener("change", (event) => {
        const selectedPaperId = parseInt(event.target.value);
        const selectedPaper = assignedPapers.find((paper) => paper.id === selectedPaperId);
        updateFormFields(selectedPaper);
    });

    function onUserLogin(userId) {
        localStorage.setItem("loggedInUserId", userId);
    }

    function updateFormFields(paper) {

        const loggedInUserId = parseInt(localStorage.getItem("loggedInUserId"));

        document.getElementById("paper-title").value = paper.title;
        document.getElementById("paper-authors").value = paper.authors
            .map((author) => `${author.firstName} ${author.lastName}`)
            .join(", ");
        document.getElementById("paper-abstract").value = paper.abstract;

        const existingReview = paper.reviews.find((review) => review.reviewerId === loggedInUserId);

        if (existingReview) {
            document.getElementById("paper-strengths").value = existingReview.paperStrengths || '';
            document.getElementById("paper-weaknesses").value = existingReview.paperWeaknesses || '';



        } else {
            document.getElementById("paper-strengths").value = '';
            document.getElementById("paper-weaknesses").value = '';

        }
    }

    async function submitPaper(paperId, paperData, reviewData) {
        const loggedInUserId = parseInt(localStorage.getItem("loggedInUserId"));
        const papers = await fetch("/data/papers.json").then((res) => res.json());
        const paperIndex = papers.findIndex((p) => p.id === paperId);
        papers[paperIndex] = {
            ...paperData,
            reviewers: papers[paperIndex].reviewers,
            reviews: papers[paperIndex].reviews
        };
        const existingReviewIndex = papers[paperIndex].reviews.findIndex((r) => r.reviewerId === loggedInUserId);


        if (existingReviewIndex !== -1) {
            papers[paperIndex].reviews[existingReviewIndex] = reviewData;
        } else {
            papers[paperIndex].reviews.push(reviewData);
        }

        await fetch("/update-paper", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(papers),
        });

        alert("Paper details and review updated successfully!");
    }


    document.getElementById("review-form").addEventListener("submit", async (event) => {
        event.preventDefault();
        const loggedInUserId = parseInt(localStorage.getItem("loggedInUserId"));
        const paperId = parseInt(document.getElementById("paper-dropdown").value);
        const title = document.getElementById("paper-title").value;
        const authors = document.getElementById("paper-authors").value.split(", ").map((fullName) => {
            const [firstName, lastName] = fullName.split(" ");
            return {
                firstName,
                lastName
            };
        });
        const paperAbstract = document.getElementById("paper-abstract").value;

        const overallEvaluation = parseInt(document.getElementById("overall-evaluation").value);
        const paperContribution = parseInt(document.getElementById("paper-contribution").value);
        const paperStrengths = document.getElementById("paper-strengths").value;
        const paperWeaknesses = document.getElementById("paper-weaknesses").value;



        const paperData = {
            id: paperId,
            title,
            authors,
            abstract: paperAbstract,
            reviewers: [],
            reviews: [],
        };

        const reviewData = {
            reviewerId: loggedInUserId,
            overallEvaluation,
            paperContribution,
            paperStrengths,
            paperWeaknesses,

        };

        await submitPaper(paperId, paperData, reviewData);
    });
    await loadAssignedPapers();
    displayAssignedPapers(assignedPapers);
}

document.addEventListener("DOMContentLoaded", init);