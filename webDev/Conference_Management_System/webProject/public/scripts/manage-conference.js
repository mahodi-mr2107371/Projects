document.addEventListener("DOMContentLoaded", async function() {
  const locations = await fetch("/data/locations.json").then((res) => res.json());
  const schedule = await fetch("/data/schedule.json")
      .then((res) => res.json())
      .then((data) => {
          if (!data.sessions) {
              data.sessions = [];
          }
          return data;
      });
  const conferenceDates = schedule.conferenceDates;

  loadLocations(locations);
  loadConferenceDates(conferenceDates);
  //displaySchedule(schedule, conferenceDates);

  document.getElementById("session-form").addEventListener("submit", async (event) => {
      event.preventDefault();
      const isNewDateAdded = addOrUpdateSession(schedule);
      if (isNewDateAdded) {
          conferenceDates.push(document.getElementById("session-date").value);
      }
      await submitConferenceSchedule(schedule, conferenceDates);
      displaySchedule(schedule.sessions, conferenceDates);
  });
});




function addOrUpdateSession(schedule) {
  const sessionTitle = document.getElementById("session-title").value;
  const sessionLocation = document.getElementById("session-location").value;
  const sessionDate = document.getElementById("session-date").value;
  const sessionTime = document.getElementById("session-time").value;

  let session = schedule.sessions.find((s) => s.time === sessionTime);

  if (!session) {
      session = {
          time: sessionTime,
          items: [],
      };
      schedule.sessions.push(session);
  }

  const existingItemIndex = session.items.findIndex((item) => item.date === sessionDate);

  const isNewDateAdded = existingItemIndex === -1;

  if (existingItemIndex !== -1) {
      session.items[existingItemIndex] = {
          date: sessionDate,
          type: "paper",
          title: sessionTitle,
          location: sessionLocation,
      };
  } else {
      session.items.push({
          date: sessionDate,
          type: "paper",
          title: sessionTitle,
          location: sessionLocation,
      });
  }

  return isNewDateAdded;
}


function loadLocations(locations) {
  const locationSelect = document.getElementById("session-location");

  locations.forEach((location) => {
      const option = document.createElement("option");
      option.value = location;
      option.innerText = location;
      locationSelect.appendChild(option);
  });
}

function loadConferenceDates(conferenceDates) {
  const dateSelect = document.getElementById("session-date");

  conferenceDates.forEach((date) => {
      const option = document.createElement("option");
      option.value = date;
      option.innerText = new Date(date).toLocaleDateString();
      dateSelect.appendChild(option);
  });
}

function displaySchedule(schedule, conferenceDates) {
  const scheduleContainer = document.getElementById("schedule-container");
  scheduleContainer.innerHTML = "";

  const table = document.createElement("table");
  const thead = document.createElement("thead");
  const headerRow = document.createElement("tr");
  ["Time", "Date", "Title", "Location"].forEach((headerText) => {
      const th = document.createElement("th");
      th.innerText = headerText;
      headerRow.appendChild(th);
  });
  thead.appendChild(headerRow);
  table.appendChild(thead);

  const tbody = document.createElement("tbody");

  schedule.sessions.forEach((session) => {
      session.items.forEach((item) => {
          const row = document.createElement("tr");
          const timeCell = document.createElement("td");
          timeCell.innerText = session.time;
          row.appendChild(timeCell);

          const dateCell = document.createElement("td");
          dateCell.innerText = new Date(item.date).toLocaleDateString();
          row.appendChild(dateCell);

          const titleCell = document.createElement("td");
          titleCell.innerText = item.title;
          row.appendChild(titleCell);

          const locationCell = document.createElement("td");
          locationCell.innerText = item.location;
          row.appendChild(locationCell);

          tbody.appendChild(row);
      });
  });

  table.appendChild(tbody);
  scheduleContainer.appendChild(table);
}


async function submitConferenceSchedule(schedule, conferenceDates) {

  const response = await fetch("/update-schedule", {
      method: "POST",
      headers: {
          "Content-Type": "application/json"
      },
      body: JSON.stringify({
          sessions: schedule.sessions,
          conferenceDates
      }),
  });

  if (response.ok) {
      alert("Schedule updated successfully!");
      localStorage.setItem("updatedSchedule", JSON.stringify({
          sessions: schedule.sessions,
          conferenceDates
      }));
      window.location.href = "/templates/display-schedule.html";
  } else {
      alert("Failed to update schedule.");
  }
}