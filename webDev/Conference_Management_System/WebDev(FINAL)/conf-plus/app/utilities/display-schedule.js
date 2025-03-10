const user = JSON.parse(localStorage.getItem("currentUser"));
const role = user.role;

let returnPage;

switch (role){
    case "author":
        returnPage = "submit-paper.html";
        break;
    case "organizer":
        returnPage = "manage-conference.html";
        break;
    case "reviewer":
        returnPage = "review-paper.html";
        break;
}

document.querySelector("#return").addEventListener("click", () => {
    window.location.href = returnPage;
})

document.addEventListener("DOMContentLoaded", async function() {
  let data = await fetch("http://localhost:3000/api/schedule");
  let scheduleData = await data.json();

  let conferenceDates = scheduleData.conferenceDates;
  let schedule = scheduleData.sessions;

  const updatedSchedule = localStorage.getItem("updatedSchedule");
  if (updatedSchedule) {
      const parsedUpdatedSchedule = JSON.parse(updatedSchedule);
      schedule = parsedUpdatedSchedule.sessions;
      conferenceDates = parsedUpdatedSchedule.conferenceDates;
      localStorage.removeItem("updatedSchedule");
  }

  displaySchedule(schedule, conferenceDates);
});

function displaySchedule(schedule, conferenceDates) {
  const scheduleContainer = document.getElementById("schedule-container");
  const table = document.createElement("table");
  const headerRow = document.createElement("tr");
  const timeHeader = document.createElement("th");
  timeHeader.innerText = "Time";
  headerRow.appendChild(timeHeader);
  conferenceDates.forEach((date) => {
      const dateHeader = document.createElement("th");
      dateHeader.innerText = new Date(date).toLocaleDateString();
      headerRow.appendChild(dateHeader);
  });

  table.appendChild(headerRow);

  schedule.sort((a, b) => (a.time > b.time ? 1 : -1));
  schedule.forEach((session) => {

      const sessionRow = document.createElement("tr");
      const timeCell = document.createElement("td");
      timeCell.innerText = session.time;
      sessionRow.appendChild(timeCell);
      conferenceDates.forEach((date) => {
          const itemsOnDate = session.items.filter(
              (item) => new Date(item.date).toISOString().slice(0, 10) === new Date(date).toISOString().slice(0, 10)
          );
          if (itemsOnDate.length > 0) {
              const sessionCell = document.createElement("td");
              sessionCell.innerHTML = itemsOnDate
                  .map((item) => `${item.title} <strong>location:</strong> ${item.location}, <strong>type:</strong> ${item.type}`)
                  .join("<br>");
              sessionRow.appendChild(sessionCell);
          } else {
              const emptyCell = document.createElement("td");
              emptyCell.innerText = "-";
              sessionRow.appendChild(emptyCell);
          }
      });

      table.appendChild(sessionRow);
  });
  scheduleContainer.appendChild(table);
}