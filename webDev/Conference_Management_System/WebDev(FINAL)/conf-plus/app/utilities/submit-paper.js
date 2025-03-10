//sample submission content as reference

const paperSubmission = {
    title: "wow a title",
    abstract: "wow an abstract",
    authors: [
        {
            fname: "jones",
            lname: "bones",
            email: "jones@bones.com",
            affiliation: "QU",
            isPresenter: true
        },
        {
            fname: "tones",
            lname: "cones",
            email: "tones@cones.com",
            affiliation: "UDST",
            isPresenter: false
        },
        {
            fname: "hones",
            lname: "rones",
            email: "hones@rones.com",
            affiliation: "CMUQ",
            isPresenter: false
        }
    ],
    reviewers: [
        27026,
        2
    ],
    fileName: "Book.pdf"
}

document.addEventListener("DOMContentLoaded", async () => {
    let data = await fetch("http://localhost:3000/api/institutions");
    const institutions = await data.json();

    let currentAuthors = 0;

    //this method generates new author detail fields upon clicking the add author button

    const addAuthorFields = () => {
        currentAuthors++;
        
        const authDiv = document.querySelector("#author-container");
        const authData = document.createElement("div");
        authData.id = `${currentAuthors}`;

        authDiv.appendChild(authData);

        const authLabel = document.createElement("label");
        authLabel.textContent = `Author ${currentAuthors}`;

        const authName1Label = document.createElement("label");
        authName1Label.htmlFor = `fname-${currentAuthors}`;
        authName1Label.textContent = "First Name: ";

        const authName1 = document.createElement("input");
        authName1.name = `fname-${currentAuthors}`;
        authName1.type = "text";
        authName1.required = true;
        
        const authName2Label = document.createElement("label");
        authName2Label.htmlFor = `lname-${currentAuthors}`;
        authName2Label.textContent = "Last Name: ";

        const authName2 = document.createElement("input");
        authName2.name = `lname-${currentAuthors}`;
        authName2.type = "text";
        authName2.required = true;

        const authEmailLabel = document.createElement("label");
        authEmailLabel.htmlFor = `email-${currentAuthors}`;
        authEmailLabel.textContent = "Email: ";

        const authEmail = document.createElement("input");
        authEmail.name = `email-${currentAuthors}`;
        authEmail.type = "email";
        authEmail.required = true;

        const authAffilLabel = document.createElement("label");
        authAffilLabel.htmlFor = `affil-${currentAuthors}`;
        authAffilLabel.textContent = "Affiliation";

        const authAffil = document.createElement("select");
        authAffil.name = `affil-${currentAuthors}`;
        institutions.forEach((inst, acc) => {
            const opt = document.createElement("option");
            opt.textContent = inst;
            opt.value = acc;
            authAffil.appendChild(opt);
        })

        let removeButton;

        if (currentAuthors > 1){
            removeButton = `<button type="button" 
                            onclick = 'removeAuthor(${currentAuthors})'>
                            Remove 
                            </button>`;
        }
        
        const line = document.createElement("hr");
        line.style = "width: 80%; border:5px solid gray; border-radius: 0.5em;";

        const linebreak = document.createElement("br");

        authData.appendChild(authLabel);
        authData.appendChild(authName1Label);
        authName1Label.appendChild(authName1);
        authData.appendChild(authName2Label);
        authName2Label.appendChild(authName2);
        authData.appendChild(authEmailLabel);
        authEmailLabel.appendChild(authEmail);
        authData.appendChild(authAffilLabel);
        authAffilLabel.appendChild(linebreak);
        authAffilLabel.appendChild(authAffil);
        if (currentAuthors > 1){
            authData.innerHTML += removeButton;
        }
        authData.appendChild(line);

        updatePresenters();
    }

    const removeAuthor = (authorDiv) => {
        console.log (authorDiv);
        const authDiv = document.querySelector("#author-container");
        const authors = authDiv.childNodes;

        authors.forEach((author, acc) => {
            if (acc >= 4){
                if (authorDiv == author.id){
                    author.remove();
                    currentAuthors--;
                    updatePresenters();
                    updateAuthors();
                    return;
                    //console.log("found " + acc);
                }
            }
        })
    }

    const getReviewerIDs = () => {

    }

    //this method updates the authors list when an author is deleted, maintaining the count in a numerical fashion

    const updateAuthors = () => {
        const authDiv = document.querySelector("#author-container");
        const authors = authDiv.childNodes;
        let count = 1;

        authors.forEach((author, acc) => {
            if (acc >= 3){
                author.id = acc;
                author.childNodes[0].textContent = `Author ${count}`;
                count++;
            }
        })
    }

    //this method updates presenters based on the number of authors in the current form data

    const updatePresenters = () => {
        const authDiv = document.querySelector("#author-container");
        const authors = authDiv.childNodes;
        //const authorsSample = authors[3].childNodes[1].childNodes[1];

        let presenterCount = 1;
        const presenters = document.querySelector("#presenter");
        presenters.innerHTML = null;

        const preLegend = document.createElement("legend");
        preLegend.textContent = "Select a Presenter";
        presenters.appendChild(preLegend);

        authors.forEach((author, acc) => {
            if (acc >= 3){
                const optDiv = document.createElement("div");
                optDiv.id = "option";

                const opt = document.createElement("input");
                opt.type = "radio";
                opt.name = `presenter`;
                opt.value = `${presenterCount}`;

                const optLabel = document.createElement("label");
                optLabel.textContent = `Author ${presenterCount}`;
                opt.htmlFor = `${presenterCount}`

                optDiv.appendChild(optLabel);
                optDiv.appendChild(opt);
                presenters.appendChild(optDiv);
                presenterCount++;
            }
        });

    }

    document.querySelector("#add-author").addEventListener("click", addAuthorFields);

    document.querySelector("#submit-btn").addEventListener("click", async () =>{

    })
    
    document.removeAuthor = removeAuthor;
    
    //Method gets called once at the initial loding of the page, at least 1 author required.
    addAuthorFields();

})