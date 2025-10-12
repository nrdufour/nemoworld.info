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
    // Initialize the theme toggle button that's already in the HTML
    const toggle = document.getElementById('theme-toggle');
    if (toggle) {
      const currentTheme = getThemePreference();
      toggle.textContent = currentTheme === 'light' ? '☾' : '☀';
      toggle.setAttribute('aria-label', currentTheme === 'light' ? 'Switch to dark theme' : 'Switch to light theme');
      toggle.onclick = toggleTheme;
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
