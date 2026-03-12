#!/usr/bin/env bash
# Streams media-control updates and fires sketchybar media_update events.
# Each JSON line from `media-control stream` is parsed and forwarded as env vars.
# Start with: killall media_stream.sh 2>/dev/null; "$CONFIG_DIR/helpers/media_stream.sh" &

/opt/homebrew/bin/media-control stream 2>/dev/null | while IFS= read -r line; do
  # Extract payload (stream lines have .payload wrapper when diff=true, raw when diff=false)
  payload=$(echo "$line" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    # stream wraps in .payload when it's a diff event; use payload if present
    p = d.get('payload', d)
    fields = [
        str(p.get('playing', False)),
        str(p.get('playbackRate', 0)),
        p.get('title', ''),
        p.get('artist', ''),
        p.get('album', ''),
        str(p.get('duration', 0)),
        str(p.get('elapsedTime', 0)),
    ]
    print('|'.join(fields))
except Exception:
    pass
" 2>/dev/null)

  [ -z "$payload" ] && continue

  IFS='|' read -r playing rate title artist album duration elapsed <<< "$payload"

  /opt/homebrew/bin/sketchybar --trigger media_update \
    playing="$playing" \
    rate="$rate" \
    title="$title" \
    artist="$artist" \
    album="$album" \
    duration="$duration" \
    elapsed="$elapsed"
done
