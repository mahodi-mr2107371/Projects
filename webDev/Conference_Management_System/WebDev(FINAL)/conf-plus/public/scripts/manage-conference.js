const user = JSON.parse(localStorage.getItem("currentUser"));
const currentRole = user.role;

if (currentRole != "organizer"){
    window.location.href = "return.html";
}

document.addEventListener("DOMContentLoaded", async function() {
  const locations = await fetch("http://localhost:3000/api/locations").then((res) => res.json());
  const schedule = await fetch("http://localhost:3000/api/schedule")
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
      window.location.href = "display-schedule.html";
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

async function submitConferenceSchedule(schedule, conferenceDates) {

  const response = await fetch("http://localhost:3000/api/schedule", {
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
      window.location.href = "display-schedule.html";
  } else {
      alert("Failed to update schedule.");
  }
}