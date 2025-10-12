// Theme switcher with system preference detection
(function() {
  const STORAGE_KEY = 'theme-preference';

  // Get theme from localStorage or system preference
  function getThemePreference() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      return stored;
    }
    return window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
  }

  // Set theme on document root
  function setTheme(theme) {
    const root = document.documentElement;
    if (theme === 'light') {
      root.setAttribute('data-theme', 'light');
    } else {
      root.removeAttribute('data-theme');
    }
    localStorage.setItem(STORAGE_KEY, theme);

    // Update toggle button if it exists
    const toggle = document.getElementById('theme-toggle');
    if (toggle) {
      toggle.textContent = theme === 'light' ? '☾' : '☀';
      toggle.setAttribute('aria-label', theme === 'light' ? 'Switch to dark theme' : 'Switch to light theme');
    }
  }

  // Toggle between themes
  function toggleTheme() {
    const current = getThemePreference();
    const next = current === 'light' ? 'dark' : 'light';
    setTheme(next);
  }

  // Apply theme immediately (before page renders)
  setTheme(getThemePreference());

  // Wait for DOM to be ready
  document.addEventListener('DOMContentLoaded', function() {
    // Create and add theme toggle button and RSS link
    const nav = document.querySelector('.nav-links');
    if (nav) {
      // RSS link
      const rssSeparator = document.createTextNode(' // ');
      const rssLink = document.createElement('a');
      rssLink.href = '/posts/index.xml';
      rssLink.className = 'rss-link';
      rssLink.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M4 11a9 9 0 0 1 9 9"></path><path d="M4 4a16 16 0 0 1 16 16"></path><circle cx="5" cy="19" r="1"></circle></svg>';
      rssLink.setAttribute('aria-label', 'Subscribe to RSS feed');
      rssLink.setAttribute('title', 'Subscribe to RSS feed');

      // Theme toggle
      const themeSeparator = document.createTextNode(' // ');
      const toggle = document.createElement('button');
      toggle.id = 'theme-toggle';
      toggle.className = 'theme-toggle';
      const currentTheme = getThemePreference();
      toggle.textContent = currentTheme === 'light' ? '☾' : '☀';
      toggle.setAttribute('aria-label', currentTheme === 'light' ? 'Switch to dark theme' : 'Switch to light theme');
      toggle.onclick = toggleTheme;

      nav.appendChild(rssSeparator);
      nav.appendChild(rssLink);
      nav.appendChild(themeSeparator);
      nav.appendChild(toggle);
    }

    // Listen for system theme changes
    window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', function(e) {
      // Only update if user hasn't set a manual preference
      if (!localStorage.getItem(STORAGE_KEY)) {
        setTheme(e.matches ? 'light' : 'dark');
      }
    });
  });
})();
