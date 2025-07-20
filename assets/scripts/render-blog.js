/*!
 * blog-render.js - Blog post renderer
 * Copyright (c) 2025 alexbraadworst
 * Licensed under the MIT License (MIT)
 * https://opensource.org/licenses/MIT
 */

fetch('/blog/posts.json')
  .then(res => res.json())
  .then(posts => {
    const tbody = document.querySelector('#blog-table tbody');

    posts.forEach(post => {
      const tr = document.createElement('tr');

      const tdTitle = document.createElement('td');
      const a = document.createElement('a');
      a.href = post.url;
      a.textContent = post.title;
      tdTitle.appendChild(a);

      const tdDate = document.createElement('td');
      tdDate.textContent = post.date;

      tr.appendChild(tdTitle);
      tr.appendChild(tdDate);

      tbody.appendChild(tr);
    });
  })
  .catch(err => {
    console.error("Failed to load blog posts:", err);
    const tbody = document.querySelector('#blog-table tbody');
    tbody.innerHTML = "<tr><td colspan='2'>Couldn't load posts.</td></tr>";
  });
