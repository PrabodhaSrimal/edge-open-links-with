// One glob per line; `*` matches anything, pattern must match the whole URL.
function parseRules(text) {
  return text.split('\n').map(s => s.trim()).filter(Boolean)
    .map(g => new RegExp('^' + g.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*') + '$'));
}

if (typeof module !== 'undefined') module.exports = { parseRules };
