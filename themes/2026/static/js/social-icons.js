// Add icons to social media links
document.addEventListener('DOMContentLoaded', function() {
  const socialIcons = {
    'github.com': '<svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path></svg>',
    'linkedin.com': '<svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path><rect x="2" y="9" width="4" height="12"></rect><circle cx="4" cy="4" r="2"></circle></svg>',
    'flickr.com': '<svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="currentColor" stroke-linecap="round" stroke-linejoin="round"><circle cx="7" cy="12" r="3"></circle><circle cx="17" cy="12" r="3"></circle></svg>',
  };

  // Mastodon icon (separate because it needs special detection)
  const mastodonIcon = '<svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21.327 8.566c0-4.339-2.843-5.61-2.843-5.61-1.433-.658-3.894-.935-6.451-.956h-.063c-2.557.021-5.016.298-6.45.956 0 0-2.843 1.272-2.843 5.61 0 .993-.019 2.181.012 3.441.103 4.243.778 8.425 4.701 9.463 1.809.479 3.362.579 4.612.51 2.268-.126 3.541-.809 3.541-.809l-.075-1.646s-1.621.511-3.441.449c-1.804-.062-3.707-.194-3.999-2.409a4.523 4.523 0 0 1-.04-.621s1.77.433 4.014.536c1.372.063 2.658-.08 3.965-.236 2.506-.299 4.688-1.843 4.962-3.254.434-2.223.398-5.424.398-5.424zm-3.353 5.59h-2.081V9.057c0-1.075-.452-1.62-1.357-1.62-1 0-1.501.647-1.501 1.927v2.791h-2.069V9.364c0-1.28-.501-1.927-1.502-1.927-.905 0-1.357.546-1.357 1.62v5.099H6.026V8.903c0-1.074.273-1.927.823-2.558.566-.631 1.307-.955 2.228-.955 1.065 0 1.872.409 2.405 1.228l.518.869.519-.869c.533-.819 1.34-1.228 2.405-1.228.92 0 1.662.324 2.228.955.549.631.822 1.484.822 2.558v5.253z"></path></svg>';

  // Function to check if a URL is a Mastodon instance
  function isMastodonUrl(url) {
    // Check if link text says "Mastodon" or if URL contains @
    return url.includes('/@') || url.toLowerCase().includes('mastodon');
  }

  // Find all links in the main content
  const links = document.querySelectorAll('main a[href^="http"]');

  links.forEach(link => {
    const href = link.getAttribute('href');
    let iconSvg = null;

    // Check if it's a Mastodon link first
    if (isMastodonUrl(href)) {
      iconSvg = mastodonIcon;
    } else {
      // Check which social media platform this link is for
      for (const [domain, svg] of Object.entries(socialIcons)) {
        if (href.includes(domain)) {
          iconSvg = svg;
          break;
        }
      }
    }

    // If we found a matching icon, add it to the link
    if (iconSvg) {
      // Create a wrapper to hold icon + text
      const wrapper = document.createElement('span');
      wrapper.className = 'social-link-wrapper';
      wrapper.innerHTML = iconSvg;

      // Move the link text into the wrapper
      const textNode = document.createTextNode(' ' + link.textContent);
      wrapper.appendChild(textNode);

      // Replace link content with wrapper
      link.textContent = '';
      link.appendChild(wrapper);
      link.classList.add('social-link');
    }
  });
});
