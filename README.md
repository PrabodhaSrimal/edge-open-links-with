# Open Links With Brave

A Microsoft Edge extension (Linux) that opens every link in Brave except those matching your keep-in-Edge URL rules.

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
3. Open the extension's **Extension options** and add the URLs to keep in Edge.

## Rules

The rules list the URLs to **keep in Edge**; every other link goes to Brave. An empty list redirects nothing.

One glob per line. `*` matches anything, and the pattern must match the whole URL.

```
https://*.sharepoint.com/*
https://login.microsoftonline.com/*
```

`https://*.sharepoint.com/*` doesn't match bare `sharepoint.com`, so give the bare domain its own line.
Add any sign-in domains your kept sites link to, or their "Sign in" links will open in Brave.

## Behaviour

- Left, middle, Ctrl and Shift clicks on `http(s)` links that match no rule are cancelled in Edge and opened in Brave.
- Same-page links (only the `#fragment` differs from the current page) always stay in Edge.
- If the handoff fails (host not installed, Brave won't start), the link opens in Edge as clicked.
  The reason is logged as `native host:` in the extension's service worker console.
- Not intercepted: Edge's right-click "Open link in new tab", typed URLs, JavaScript navigations,
  and clicks made before a page's rules finish loading.

## Layout

| Path | Purpose |
|------|---------|
| `extension/content.js` | Intercepts clicks on matching links |
| `extension/background.js` | Calls the native host; opens in Edge on failure |
| `extension/rules.js` | Parses the rules and decides whether a link is redirected |
| `extension/options.*` | Rules editor |
| `host/open_in_brave.py` | Native host that launches Brave |
| `host/install.sh` | Registers the host with Edge |

## Test

```sh
./test.sh
```

Checks glob matching, the keep-list decision, and that the host rejects anything that isn't an `http(s)` URL. Requires `node` and `python3`.
