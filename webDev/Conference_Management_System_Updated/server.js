const express = require("express");
const path = require("path");
const fs = require("fs");

const app = express();
app.use(express.json());
app.use("/public", express.static(path.join(__dirname, "public")));

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/review-paper.html"));
});

app.get('/data/locations.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'locations.json'));
});

app.get('/data/conference-dates.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'conference-dates.json'));
});

app.get('/data/sessions.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'sessions.json'));
});

app.post('/update-schedule', async (req, res) => {
  const newSchedule = req.body;

  try {
    await fs.promises.writeFile("data/schedule.json", JSON.stringify(newSchedule, null, 2));
    res.sendStatus(200);
  } catch (err) {
    console.error("Failed to update schedule:", err);
    res.sendStatus(500);
  }
});

app.get('/data/papers.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'papers.json'));
});


app.get("/templates/display-schedule.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/display-schedule.html"));
});


app.get("/templates/login.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/login.html"));
});

app.get("/templates/submit-paper.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/submit-paper.html"));
});

app.get("/templates/review-paper.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/review-paper.html"));
});

app.get("/templates/manage-conference.html", (req, res) => {
  res.sendFile(path.join(__dirname, "public/templates/manage-conference.html"));
});

app.get('/data/schedule.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'schedule.json'));
});

app.get('/data/users.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'users.json'));
});

app.get('/data/papers.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'papers.json'));
});

app.get('/data/institutions.json', (req, res) => {
  res.sendFile(path.join(__dirname, 'data', 'institutions.json'));
});




app.post("/data/papers.json", async (req, res) => {
  try {
    const papersPath = path.join(__dirname, "data", "papers.json");
    const papers = JSON.parse(await fs.promises.readFile(papersPath, "utf8"));

    const newPaperId = papers.length ? Math.max(...papers.map((paper) => paper.id)) + 1 : 1;
    const newPaper = { id: newPaperId, ...req.body };

    papers.push(newPaper);
    await fs.promises.writeFile(papersPath, JSON.stringify(papers, null, 2));

    res.sendStatus(200);
  } catch (error) {
    console.error("Error adding paper:", error);
    res.sendStatus(500);
  }

});

app.post('/update-paper', async (req, res) => {
  const updatedPapers = req.body;

  try {
    await fs.promises.writeFile("data/papers.json", JSON.stringify(updatedPapers, null, 2));
    res.sendStatus(200);
  } catch (err) {
    console.error("Failed to update papers:", err);
    res.sendStatus(500);
  }
});

app.listen(4000, () => {
  console.log("Server is running on port 4000");
});
