#!/usr/bin/env python3
"""Edge native-messaging host: reads {"url": ...}, opens it in Brave, replies {"ok": bool}."""
import json
import struct
import subprocess
import sys
from urllib.parse import urlsplit

BRAVE = ['brave-browser']


def main():
    (n,) = struct.unpack('=I', sys.stdin.buffer.read(4))
    url = json.loads(sys.stdin.buffer.read(n)).get('url', '')
    # Only http(s): also guarantees the URL can't be parsed as a Brave CLI flag.
    ok = urlsplit(url).scheme in ('http', 'https')
    if ok:
        try:
            subprocess.Popen(BRAVE + [url], start_new_session=True,
                             stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except OSError:
            ok = False
    out = json.dumps({'ok': ok}).encode()
    sys.stdout.buffer.write(struct.pack('=I', len(out)) + out)
    sys.stdout.buffer.flush()


if __name__ == '__main__':
    main()
