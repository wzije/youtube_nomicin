final String YoutubeTVModeScript = """
(function () {

  function forceHome() {
    document.body.innerHTML = '';
    history.pushState(null, '', '/');
    location.reload();
  }

  function blockShortsAndRedirect() {

    const path = window.location.pathname;
    const url = window.location.href;

    // 1. BLOCK SHORTS TOTAL (FIX)
    if (path.startsWith('/shorts')) {
      forceHome();
      return;
    }

    // 2. PAKSA VIDEO KE EMBED MODE
    if (url.includes('/watch?v=')) {
      const videoId = new URL(url).searchParams.get('v');
      if (videoId && !url.includes('/embed/')) {
        window.location.href = 'https://www.youtube.com/embed/' + videoId;
        return;
      }
    }
  }

  function cleanUI() {

    // Hapus sidebar & komentar
    document.querySelectorAll('#secondary, #comments').forEach(el => el.remove());

    // Hapus tombol open app
    document.querySelectorAll('*').forEach(el => {
      const text = el.innerText?.toLowerCase() || '';
      if (text.includes('open app') || text.includes('buka aplikasi')) {
        el.remove();
      }
    });

    // Fallback hide shorts
    document.querySelectorAll(
      'ytd-rich-shelf-renderer[is-shorts], a[href*="/shorts"]'
    ).forEach(el => el.remove());

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

  function injectStyle() {
    const style = document.createElement('style');

    style.innerHTML = `
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
    `;

    document.head.appendChild(style);
  }

  function init() {
    blockShortsAndRedirect();
    cleanUI();
  }

  // 🔥 PENTING: hook navigation YouTube (SPA)
  window.addEventListener('yt-navigate-start', () => {
    if (location.pathname.startsWith('/shorts')) {
      forceHome();
    }
  });

  // Loop ringan
  setInterval(init, 1500);

  injectStyle();
  init();

})();
""";
