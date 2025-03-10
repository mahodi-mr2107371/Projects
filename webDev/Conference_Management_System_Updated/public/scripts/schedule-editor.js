document.addEventListener("DOMContentLoaded", async function() {
  const locations = await fetch("/data/locations.json").then((res) => res.json());
  const conferenceDates = await fetch("/data/conference-dates.json").then((res) => res.json());
  const papers = await fetch("/data/papers.json").then((res) => res.json());
  const sessions = await fetch("/data/sessions.json").then((res) => res.json());

  displayScheduleEditor(locations, conferenceDates, papers, sessions);
});

function displayScheduleEditor(locations, conferenceDates, papers, sessions) {
  const scheduleEditorContainer = document.getElementById("schedule-editor-container");

  const table = document.createElement("table");
  const thead = document.createElement("thead");
  const tr = document.createElement("tr");

  ["Date", "Time", "Location", "Papers", "Actions"].forEach((header) => {
      const th = document.createElement("th");
      th.textContent = header;
      tr.appendChild(th);
  });

  thead.appendChild(tr);
  table.appendChild(thead);
  const tbody = document.createElement("tbody");
  table.appendChild(tbody);
  scheduleEditorContainer.appendChild(table);

  function addRow(session = {}) {
      const tr = document.createElement("tr");

      const dateInput = document.createElement("input");
      dateInput.type = "date";
      dateInput.value = session.date || "";
      tr.appendChild(createCell(dateInput));

      const timeInput = document.createElement("input");
      timeInput.type = "time";
      timeInput.value = session.time || "";
      tr.appendChild(createCell(timeInput));

      const locationSelect = document.createElement("select");
      locations.forEach((location) => {
          const option = document.createElement("option");
          option.value = location;
          option.textContent = location;
          if (session.location === location) {
              option.selected = true;
          }
          locationSelect.appendChild(option);
      });
      tr.appendChild(createCell(locationSelect));

      const paperSelect = document.createElement("select");
      papers.forEach((paper) => {
          const option = document.createElement("option");
          option.value = paper.id;
          option.textContent = paper.title;
          if (session.paperId === paper.id) {
              option.selected = true;
          }
          paperSelect.appendChild(option);
      });
      tr.appendChild(createCell(paperSelect));

      const actionsCell = document.createElement("td");
      const deleteButton = document.createElement("button");
      deleteButton.textContent = "Delete";
      deleteButton.onclick = () => tr.remove();
      actionsCell.appendChild(deleteButton);
      tr.appendChild(actionsCell);

      tbody.appendChild(tr);
  }

  function createCell(content) {
      const td = document.createElement("td");
      td.appendChild(content);
      return td;
  }

  sessions.forEach(addRow);

  const addButton = document.createElement("button");
  addButton.textContent = "Add session";
  addButton.onclick = () => addRow();
  scheduleEditorContainer.appendChild(addButton);

  const saveButton = document.createElement("button");
  saveButton.textContent = "Save schedule";
  saveButton.onclick = () => saveSchedule(tbody);
  scheduleEditorContainer.appendChild(saveButton);
}

async function saveSchedule(tbody) {
  const sessions = [];

  for (const row of tbody.querySelectorAll("tr")) {
      const session = {
          date: row.children[0].querySelector("input").value,
          time: row.children[1].querySelector("input").value,
          location: row.children[2].querySelector("select").value,
          paperId: parseInt(row.children[3].querySelector("select").value),
      };
      sessions.push(session);
  }

  const response = await fetch("/save-schedule", {
      method: "POST",
      headers: {
          "Content-Type": "application/json",
      },
      body: JSON.stringify({
          sessions
      }),
  });

  if (response.ok) {
      alert("Schedule saved successfully!");
  } else {
      alert("Failed to save schedule!");
  }
}