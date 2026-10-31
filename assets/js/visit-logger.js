(() => {
  "use strict";
  const script = document.currentScript;
  if (!script || location.origin !== script.dataset.siteOrigin ||
      !["/", "/publications/", "/about/"].includes(location.pathname)) return;
  // One event per document, including accidental duplicate script execution.
  const guard = Symbol.for("academic.visitLogger.sent");
  if (window[guard]) return;
  window[guard] = true;
  const event = { page: location.pathname, referrer: document.referrer };
  try {
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    if (typeof timezone === "string" && timezone.trim()) event.browserTimezone = timezone;
  } catch { /* Optional browser information must not prevent the visit. */ }
  void fetch(script.dataset.endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "omit",
    keepalive: true,
    body: JSON.stringify(event),
  }).catch(() => { /* Analytics failure must never affect navigation. No retries. */ });
})();