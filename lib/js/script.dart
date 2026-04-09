final String YoutubeTVModeScript = """
(function () {

  // 🔹 Force redirect ke homepage
  function forceHome() {
    if (window.location.pathname !== '/') {
      history.pushState(null, '', '/');
      location.reload();
    }
  }

  // 🔹 Block Shorts & redirect /watch?v= → embed
  function blockShortsAndRedirect() {
    const path = window.location.pathname;
    const url = window.location.href;

    // 1. Block Shorts
    if (path.startsWith('/shorts')) {
      forceHome();
      return;
    }

    // 2. Redirect video ke embed dengan autoplay + mute
    if (url.includes('/watch?v=')) {
      const videoId = new URL(url).searchParams.get('v');
      if (videoId && !url.includes('/embed/')) {
        window.location.replace(
          'https://www.youtube.com/embed/' + videoId + '?autoplay=1&mute=1&modestbranding=1&rel=0'
        );
        return;
      }
    }
  }

  // 🔹 Clean UI
  function cleanUI() {
    // Hapus sidebar & komentar
    document.querySelectorAll('#secondary, #comments').forEach(el => el.remove());

    // Hapus tombol "open app" atau "buka aplikasi"
    document.querySelectorAll('ytd-button-renderer, *').forEach(el => {
      const text = el.innerText?.toLowerCase() || '';
      if (text.includes('open app') || text.includes('buka aplikasi')) {
        el.remove();
      }
    });

    // Hapus shorts fallback
    document.querySelectorAll(
      'ytd-rich-shelf-renderer[is-shorts], a[href*="/shorts"]'
    ).forEach(el => el.remove());

    // Hapus video yang mengandung keyword tertentu
    const blocked = ['roblox', 'minecraft', 'game'];
    document.querySelectorAll('ytd-rich-item-renderer, ytd-video-renderer').forEach(el => {
      const text = el.innerText?.toLowerCase() || '';
      for (let keyword of blocked) {
        if (text.includes(keyword)) {
          el.remove();
          break;
        }
      }
    });
  }

  // 🔹 Inject CSS untuk UI minimal
  function injectStyle() {
    const style = document.createElement('style');
    style.innerHTML = \`
      body {
        background: black !important;
        overflow-x: hidden;
      }

      ytd-rich-shelf-renderer[is-shorts],
      ytm-shorts-lockup-view-model,
      ytm-shorts-lockup-view-model-v2,
      a[href*="/shorts"] {
        display: none !important;
      }
    \`;
    
    document.head.appendChild(style);

    
  }

  // 🔹 Init functions
  function init() {
    blockShortsAndRedirect();
    cleanUI();
  }

  // 🔹 Hook navigasi SPA YouTube
  window.addEventListener('yt-navigate-start', () => {
    if (location.pathname.startsWith('/shorts')) {
      forceHome();
    }
  });

  // 🔹 Loop ringan setiap 2 detik (cukup)
  setInterval(init, 2000);

  // 🔹 Inject style dan jalankan init sekali
  injectStyle();
  init();

})();
""";
