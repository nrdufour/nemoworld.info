// Simple image gallery using native <dialog> element
document.addEventListener('DOMContentLoaded', () => {
  // Find all gallery images
  document.querySelectorAll('.image-gallery a, .drawings figure a').forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();

      // Create dialog
      const dialog = document.createElement('dialog');
      dialog.className = 'image-dialog';

      // Add image and close button
      const img = document.createElement('img');
      img.src = link.href;
      img.alt = link.querySelector('img')?.alt || '';

      const closeBtn = document.createElement('button');
      closeBtn.className = 'dialog-close';
      closeBtn.innerHTML = '×';
      closeBtn.onclick = () => {
        dialog.close();
        dialog.remove();
      };

      dialog.appendChild(img);
      dialog.appendChild(closeBtn);

      // Close on backdrop click
      dialog.onclick = (e) => {
        if (e.target === dialog) {
          dialog.close();
          dialog.remove();
        }
      };

      // Close on Escape key
      dialog.onclose = () => dialog.remove();

      document.body.appendChild(dialog);
      dialog.showModal();
    });
  });

  // Back to top button
  const backToTop = document.createElement('button');
  backToTop.className = 'back-to-top';
  backToTop.innerHTML = '↑';
  backToTop.title = 'Back to top';
  backToTop.onclick = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  document.body.appendChild(backToTop);

  // Show/hide button based on scroll position
  let scrollTimeout;
  window.addEventListener('scroll', () => {
    clearTimeout(scrollTimeout);
    scrollTimeout = setTimeout(() => {
      if (window.scrollY > 300) {
        backToTop.classList.add('visible');
      } else {
        backToTop.classList.remove('visible');
      }
    }, 100);
  });
});
