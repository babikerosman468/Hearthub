document.addEventListener('DOMContentLoaded', () => {
  const cards = document.querySelectorAll('.card');
  const content = document.getElementById('content');

  const pages = {
    home: `
      <h2>Home</h2>
      <p>Welcome to the Home page. This is where your main content lives.</p>
    `,
    about: `
      <h2>About</h2>
      <p>Learn more about us on this About page. Replace with real info.</p>
    `,
    services: `
      <h2>Services</h2>
      <p>Details about the services offered go here.</p>
    `,
    contact: `
      <h2>Contact</h2>
      <p>How to reach us. Email, phone, etc.</p>
    `
  };

  cards.forEach(card => {
    card.addEventListener('click', e => {
      e.preventDefault();
      const page = card.dataset.content;
      content.innerHTML = pages[page] || '<h2>404</h2><p>Content not found.</p>';
    });
  });
});


