/* BARISOLAN - Supabase connection */

(function () {
  "use strict";

  const config = window.BARISOLAN_CONFIG;

  if (!config || !config.supabase) {
    console.error("BARISOLAN config not found.");
    return;
  }

  const { url, anonKey } = config.supabase;

  if (!url || !anonKey) {
    console.warn("Supabase connection is not configured yet.");
    return;
  }

  if (!window.supabase) {
    console.error("Supabase library is not loaded.");
    return;
  }

  window.barIsolanDB = window.supabase.createClient(
    url,
    anonKey
  );
})();
