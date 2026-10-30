(() => {
  "use strict";
  const script = document.currentScript;
  if (!script || location.origin !== script.dataset.siteOrigin ||
      !["/", "/publications/", "/about/"].includes(location.pathname)) return;
  // One event per document, including accidental duplicate script execution.
  const guard = Symbol.for("academic.visitLogger.sent");
  if (window[guard]) return;
  window[guard] = true;
  void fetch(script.dataset.endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "omit",
    keepalive: true,
    body: JSON.stringify({ page: location.pathname, referrer: document.referrer }),
  }).catch(() => { /* Analytics failure must never affect navigation. No retries. */ });
})();