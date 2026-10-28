// One glob per line; `*` matches anything, pattern must match the whole URL.
function parseRules(text) {
  return text.split('\n').map(s => s.trim()).filter(Boolean)
    .map(g => new RegExp('^' + g.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*') + '$'));
}

// Rules are a keep-in-Edge list: redirect http(s) links that match none of them.
// Empty list = redirect nothing. Same-page #fragment links always stay.
function shouldRedirect(href, pageHref, keep) {
  if (!keep.length || !/^https?:/.test(href)) return false;
  if (href.includes('#') && href.split('#')[0] === pageHref.split('#')[0]) return false;
  return !keep.some(r => r.test(href));
}

if (typeof module !== 'undefined') module.exports = { parseRules, shouldRedirect };
