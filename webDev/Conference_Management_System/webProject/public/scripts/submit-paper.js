initSubmitPaper();

function initSubmitPaper() {
    const addAuthorBtn = document.querySelector("#add-author");
    const removeAuthorBtn = document.querySelector("#remove-author");
    const authorContainer = document.querySelector("#author-container");
    const submitBtn = document.querySelector("#submit-btn");
    const paperForm = document.querySelector("#paper-form");

    addAuthorBtn.addEventListener("click", () => {
        addAuthorInput();
    });

    removeAuthorBtn.addEventListener("click", () => {
        removeAuthorInput();
    });

    submitBtn.addEventListener("click", async (event) => {
        event.preventDefault();

        const title = document.querySelector("#title").value;
        const abstract = document.querySelector("#abstract").value;
        const authors = getAuthors();
        const file = document.querySelector("#file").files[0];

        if (!title || !abstract || authors.length === 0 || !file) {
            alert("Please fill in all required fields.");
            return;
        }

        const reviewers = await getRandomReviewers(2);
        const formData = new FormData();

        formData.append("title", title);
        formData.append("abstract", abstract);
        formData.append("authors", JSON.stringify(authors));
        formData.append("reviewers", JSON.stringify(reviewers));
        formData.append("file", file);

        fetch("/api/papers", {
                method: "POST",
                body: formData,
            })
            .then((response) => {
                if (response.ok) {
                    alert("Paper submitted successfully!");
                    paperForm.reset();
                } else {
                    alert("Error submitting paper. Please try again.");
                }
            })
            .catch((error) => {
                console.error("Error submitting paper:", error);
            });
    });

    async function addAuthorInput() {
        const institutions = await fetch("/data/institutions.json").then((res) => res.json());

        const authorDiv = document.createElement("div");
        authorDiv.classList.add("author");

        const firstNameInput = document.createElement("input");
        firstNameInput.type = "text";
        firstNameInput.placeholder = "First Name";
        firstNameInput.required = true;
        authorDiv.appendChild(firstNameInput);

        const lastNameInput = document.createElement("input");
        lastNameInput.type = "text";
        lastNameInput.placeholder = "Last Name";
        lastNameInput.required = true;
        authorDiv.appendChild(lastNameInput);

        const emailInput = document.createElement("input");
        emailInput.type = "email";
        emailInput.placeholder = "Email";
        emailInput.required = true;
        authorDiv.appendChild(emailInput);

        const affiliationSelect = document.createElement("select");
        institutions.forEach((institution) => {
            const option = document.createElement("option");
            option.value = institution;
            option.innerText = institution;
            affiliationSelect.appendChild(option);
        });
        authorDiv.appendChild(affiliationSelect);

        const isPresenterCheckbox = document.createElement("input");
        isPresenterCheckbox.type = "checkbox";
        isPresenterCheckbox.classList.add("presenter");
        authorDiv.appendChild(isPresenterCheckbox);
        const presenterLabel = document.createElement("label");
        presenterLabel.innerText = "Presenter";
        authorDiv.appendChild(presenterLabel);

        authorContainer.appendChild(authorDiv);
    }

    function removeAuthorInput() {
        const authors = authorContainer.querySelectorAll(".author");
        if (authors.length > 1) {
            authorContainer.removeChild(authors[authors.length - 1]);
        }
    }

    function getAuthors() {
        const authors = [];
        const authorElements = authorContainer.querySelectorAll(".author");

        authorElements.forEach((authorElement) => {
            const firstName = authorElement.querySelector("input[type='text']:nth-child(1)").value;
            const lastName = authorElement.querySelector("input[type='text']:nth-child(2)").value;
            const email = authorElement.querySelector("input[type='email']").value;
            const affiliation = authorElement.querySelector("select").value;
            const isPresenter = authorElement.querySelector(".presenter").checked;

            authors.push({
                firstName,
                lastName,
                email,
                affiliation,
                isPresenter,
            });
        });

        return authors;
    }


    async function getRandomReviewers(count) {
        const response = await fetch("/data/users.json");
        const users = await response.json();
        const reviewers = users.filter((user) => user.role === "reviewer");

        if (count > reviewers.length) {
            console.warn("Requested more reviewers than available, returning all reviewers.");
            return reviewers.map((reviewer) => reviewer.id);
        }

        const selectedReviewers = [];
        while (selectedReviewers.length < count) {
            const randomIndex = Math.floor(Math.random() * reviewers.length);
            const reviewer = reviewers[randomIndex];

            if (!selectedReviewers.includes(reviewer)) {
                selectedReviewers.push(reviewer);
            }
        }

        return selectedReviewers.map((reviewer) => reviewer.id);
    }

}
export {
    initSubmitPaper
};