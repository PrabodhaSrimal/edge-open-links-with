#!/bin/sh
# Checks glob matching, the keep-list redirect decision, and the native host's framing/URL validation (without launching Brave).
set -e
cd "$(dirname "$0")"
node -e '
const assert = require("assert");
const { parseRules, shouldRedirect } = require("./extension/rules.js");
const r = parseRules("https://*.youtube.com/*\n\n  https://a.b/x?y=*  ");
const m = u => r.some(x => x.test(u));
assert(m("https://www.youtube.com/watch?v=1"));
assert(!m("https://youtube.com/watch"));        // bare domain needs its own rule
assert(!m("https://www.youtube.com.evil.io/")); // whole-URL anchoring
assert(m("https://a.b/x?y=1"));                 // regex chars are literal
assert(!m("https://aXb/x?y=1"));

const page = "https://www.youtube.com/watch?v=1#t=5";
const go = u => shouldRedirect(u, page, r);
assert(!go("https://www.youtube.com/feed"));     // kept: matches a rule
assert(go("https://example.com/"));              // redirected: matches none
assert(!go("mailto:a@b.c"));                     // non-http(s) left alone
assert(!go("https://www.youtube.com/watch?v=1#comments")); // same-page anchor
assert(!shouldRedirect("https://other.io/p#x", "https://other.io/p", r)); // anchor on off-list page
assert(shouldRedirect("https://other.io/q#x", "https://other.io/p", r));  // other page with a hash
assert(!shouldRedirect("https://example.com/", page, []));               // empty list = off
'
reply=$(python3 -c 'import json,struct,sys;m=json.dumps({"url":"javascript:alert(1)"}).encode();sys.stdout.buffer.write(struct.pack("=I",len(m))+m)' \
  | python3 host/open_in_brave.py | tail -c +5)
[ "$reply" = '{"ok": false}' ] || { echo "host reply: $reply"; exit 1; }
echo OK
