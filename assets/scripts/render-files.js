/*!
 * file-render.js - JSON file list renderer
 * Copyright (c) 2025 alexbraadworst
 * Licensed under the MIT License (MIT)
 * https://opensource.org/licenses/MIT
 */

fetch('/fileshare/files.json')
  .then(res => res.json())
  .then(files => {
    const tbody = document.querySelector('#files-table tbody');

    files.forEach(file => {
      const tr = document.createElement('tr');

      const tdName = document.createElement('td');
      tdName.textContent = file.name;

      const tdLink = document.createElement('td');
      const a = document.createElement('a');
      a.href = file.url;
      a.textContent = file.url;
      a.target = "_blank";
      tdLink.appendChild(a);

      const tdPurpose = document.createElement('td');
      tdPurpose.textContent = file.purpose;

      tr.appendChild(tdName);
      tr.appendChild(tdLink);
      tr.appendChild(tdPurpose);

      tbody.appendChild(tr);
    });
  })
  .catch(err => {
    console.error("Failed to load file list:", err);
    const tbody = document.querySelector('#files-table tbody');
    tbody.innerHTML = "<tr><td colspan='3'>Couldn't load file list.</td></tr>";
  });
