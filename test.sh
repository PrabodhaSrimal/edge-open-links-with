#!/bin/sh
# Checks glob matching and the native host's framing/URL validation (without launching Brave).
set -e
cd "$(dirname "$0")"
node -e '
const assert = require("assert");
const { parseRules } = require("./extension/glob.js");
const r = parseRules("https://*.youtube.com/*\n\n  https://a.b/x?y=*  ");
const m = u => r.some(x => x.test(u));
assert(m("https://www.youtube.com/watch?v=1"));
assert(!m("https://youtube.com/watch"));        // bare domain needs its own rule
assert(!m("https://www.youtube.com.evil.io/")); // whole-URL anchoring
assert(m("https://a.b/x?y=1"));                 // regex chars are literal
assert(!m("https://aXb/x?y=1"));
'
reply=$(python3 -c 'import json,struct,sys;m=json.dumps({"url":"javascript:alert(1)"}).encode();sys.stdout.buffer.write(struct.pack("=I",len(m))+m)' \
  | python3 host/open_in_brave.py | tail -c +5)
[ "$reply" = '{"ok": false}' ] || { echo "host reply: $reply"; exit 1; }
echo OK
