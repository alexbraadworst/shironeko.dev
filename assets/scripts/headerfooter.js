/*!
 * headerfooter.js - Header and footer HTML loader
 * Copyright (c) 2025 alexbraadworst
 * Licensed under the MIT License (MIT)
 * https://opensource.org/licenses/MIT
 */

fetch('/assets/header.html')
  .then(response => response.text())
  .then(data => {
    document.getElementById('header-placeholder').innerHTML = data;
  })
  .catch(() => {
    console.warn('Failed to load header.');
  });
  
fetch('/assets/footer.html')
  .then(response => response.text())
  .then(data => {
    document.getElementById('footer-placeholder').innerHTML = data;
  })
  .catch(() => {
    console.warn('Failed to load footer.');
  });