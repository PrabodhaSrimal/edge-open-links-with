#!/bin/sh
# Registers the native host with Edge. Re-run if you move this folder.
set -e
dir=$(cd "$(dirname "$0")" && pwd)
dest="$HOME/.config/microsoft-edge/NativeMessagingHosts"
mkdir -p "$dest"
chmod +x "$dir/open_in_brave.py"
cat > "$dest/open_links_with.brave.json" <<EOF
{
  "name": "open_links_with.brave",
  "description": "Open links in Brave",
  "path": "$dir/open_in_brave.py",
  "type": "stdio",
  "allowed_origins": ["chrome-extension://jgleohmkpipghajknakmcilmgklmhphf/"]
}
EOF
echo "Installed $dest/open_links_with.brave.json"
