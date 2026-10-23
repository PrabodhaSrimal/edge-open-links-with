# Open Links With Brave

A Microsoft Edge extension (Linux) that opens links matching your URL rules in Brave instead of Edge.

Browsers don't let extensions start programs, so the extension sends the URL to a small Python
[native messaging](https://learn.microsoft.com/microsoft-edge/extensions/developer-guide/native-messaging)
host, which runs `brave-browser <url>`.

## Install

1. Register the native host (re-run if you move this folder):
   ```sh
   ./host/install.sh
   ```
2. In Edge, open `edge://extensions`, enable **Developer mode**, click **Load unpacked** and pick `extension/`.
   The ID must be `jgleohmkpipghajknakmcilmgklmhphf` (pinned via `key` in `manifest.json`).
3. Open the extension's **Extension options** and add rules.

## Rules

One glob per line. `*` matches anything, and the pattern must match the whole URL.

```
https://*.youtube.com/*
https://youtube.com/*
```

`https://*.youtube.com/*` doesn't match bare `youtube.com`, so give the bare domain its own line.

## Behaviour

- Left, middle, Ctrl and Shift clicks on matching `http(s)` links are cancelled in Edge and opened in Brave.
- If the handoff fails (host not installed, Brave won't start), the link opens in Edge as clicked.
  The reason is logged as `native host:` in the extension's service worker console.
- Not intercepted: Edge's right-click "Open link in new tab", typed URLs, JavaScript navigations,
  and clicks made before a page's rules finish loading.

## Layout

| Path | Purpose |
|------|---------|
| `extension/content.js` | Intercepts clicks on matching links |
| `extension/background.js` | Calls the native host; opens in Edge on failure |
| `extension/glob.js` | Turns the rules into regexes |
| `extension/options.*` | Rules editor |
| `host/open_in_brave.py` | Native host that launches Brave |
| `host/install.sh` | Registers the host with Edge |

## Test

```sh
./test.sh
```

Checks glob matching and that the host rejects anything that isn't an `http(s)` URL. Requires `node` and `python3`.
