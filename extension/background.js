chrome.runtime.onMessage.addListener((msg, sender, reply) => {
  if (msg.fallback) {
    chrome.tabs.create({ url: msg.fallback, openerTabId: sender.tab.id, index: sender.tab.index + 1, active: false });
    return;
  }
  chrome.runtime.sendNativeMessage('open_links_with.brave', { url: msg.url }, res => {
    if (chrome.runtime.lastError) console.warn('native host:', chrome.runtime.lastError.message);
    reply({ ok: !chrome.runtime.lastError && res?.ok === true });
  });
  return true; // keep reply() alive for the async native call
});
