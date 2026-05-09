#!/bin/zsh

# Instagram Batch Downloader
# Put this file in the folder where you want videos saved.
# Add Instagram URLs to links.txt, then double-click this file.

set -e

SCRIPT_DIR="${0:A:h}"
cd "$SCRIPT_DIR"

LINKS_FILE="$SCRIPT_DIR/links.txt"
DOWNLOAD_DIR="$SCRIPT_DIR/videos"
ARCHIVE_FILE="$SCRIPT_DIR/downloaded.txt"
LOG_FILE="$SCRIPT_DIR/download-log.txt"

mkdir -p "$DOWNLOAD_DIR"

clear
echo "Instagram Batch Downloader"
echo "Working folder:"
echo "$SCRIPT_DIR"
echo ""

# Check yt-dlp
if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp is not installed."
  echo ""
  echo "Install it with Homebrew:"
  echo "  brew install yt-dlp"
  echo ""
  echo "Then double-click this file again."
  echo ""
  echo "Press any key to close."
  read -k 1
  exit 1
fi

# Create links.txt if it does not exist
if [ ! -f "$LINKS_FILE" ]; then
  cat > "$LINKS_FILE" <<'EOF'
# Paste Instagram URLs below, one per line.
# Lines starting with # are ignored.

EOF
  open -a TextEdit "$LINKS_FILE"
  echo "Created links.txt."
  echo "Paste your Instagram URLs in that file, save it, then run this again."
  echo ""
  echo "Press any key to close."
  read -k 1
  exit 0
fi

# Check whether links.txt contains at least one URL-ish line
if ! grep -Eqi 'https?://(www\.)?instagram\.com/' "$LINKS_FILE"; then
  open -a TextEdit "$LINKS_FILE"
  echo "No Instagram URLs found in links.txt."
  echo "Paste URLs in that file, save it, then run this again."
  echo ""
  echo "Press any key to close."
  read -k 1
  exit 0
fi

echo "Starting downloads..."
echo "Videos will go into:"
echo "$DOWNLOAD_DIR"
echo ""

yt-dlp \
  --batch-file "$LINKS_FILE" \
  --ignore-errors \
  --no-overwrites \
  --continue \
  --download-archive "$ARCHIVE_FILE" \
  --sleep-requests 3 \
  --sleep-interval 5 \
  --max-sleep-interval 15 \
  --output "$DOWNLOAD_DIR/%(uploader)s/%(upload_date)s_%(id)s_%(title).80s.%(ext)s" \
  2>&1 | tee "$LOG_FILE"

echo ""
echo "Done."
echo "Downloaded / skipped items are tracked in downloaded.txt."
echo "Log saved to download-log.txt."
echo ""
echo "Press any key to close."
read -k 1
