let rules = [];
const load = () => chrome.storage.sync.get({ rules: '' }, d => { rules = parseRules(d.rules); });
load();
chrome.storage.onChanged.addListener(load);

function onClick(e) {
  // Untrusted = page-scripted clicks, including our own fallback a.click() below.
  if (!e.isTrusted || e.button > 1) return;
  const a = e.composedPath().find(n => n instanceof HTMLAnchorElement && n.href);
  if (!a || !/^https?:/.test(a.href) || !rules.some(r => r.test(a.href))) return;

  e.preventDefault();
  e.stopImmediatePropagation();
  const newTab = e.button === 1 || e.ctrlKey || e.metaKey || e.shiftKey;
  chrome.runtime.sendMessage({ url: a.href }, res => {
    if (res?.ok) return;
    // Handoff failed: open in Edge as the user clicked it.
    if (newTab) chrome.runtime.sendMessage({ fallback: a.href });
    else a.click();
  });
}

addEventListener('click', onClick, true);
addEventListener('auxclick', onClick, true);
