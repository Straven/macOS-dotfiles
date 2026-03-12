local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local popup_width = 233
local ART_PATH    = "/tmp/sketchybar_art.jpg"

-- ── Helpers ────────────────────────────────────────────────────────────────

local function fmt_time(secs)
  secs = math.floor(tonumber(secs) or 0)
  return string.format("%d:%02d", math.floor(secs / 60), secs % 60)
end

-- ── media-control poll ─────────────────────────────────────────────────────
-- Outputs: playing|playbackRate|title|artist|album|duration|elapsedTime
-- Or:      none

-- Uses --now flag to get elapsedTimeNow (current estimated position).
-- Filters to Spotify and Apple Music only via bundleIdentifier.
-- Output: playing|playbackRate|title|artist|album|duration|elapsedTimeNow
local ALLOWED_BUNDLES = {
  ["com.spotify.client"]  = true,
  ["com.apple.Music"]     = true,
}

local GET_CMD = [[
/opt/homebrew/bin/media-control get --now 2>/dev/null | python3 -c "
import sys, json
ALLOWED = {'com.spotify.client', 'com.apple.Music'}
try:
    d = json.load(sys.stdin)
    if d.get('bundleIdentifier', '') not in ALLOWED:
        print('none')
        sys.exit(0)
    fields = [
        str(d.get('playing', False)),
        str(d.get('playbackRate', 0)),
        d.get('title', ''),
        d.get('artist', ''),
        d.get('album', ''),
        str(d.get('duration', 0)),
        str(d.get('elapsedTimeNow', 0)),
    ]
    print('|'.join(fields))
except Exception:
    print('none')
" 2>/dev/null || printf "none"
]]

-- ── Artwork fetch ──────────────────────────────────────────────────────────
-- Decodes artworkData from media-control JSON → /tmp/sketchybar_art.jpg

local FETCH_ART_CMD = [[
set -e
# 1. Decode base64 artwork to raw file
/opt/homebrew/bin/media-control get 2>/dev/null | python3 -c "
import sys, json, base64
try:
    d = json.load(sys.stdin)
    data = d.get('artworkData', '')
    if not data: sys.exit(1)
    open('/tmp/sketchybar_art_raw.jpg','wb').write(base64.b64decode(data))
except: sys.exit(1)
" 2>/dev/null || { printf fail; exit 1; }
# 2. Get image dimensions
INFO=$(sips -g pixelWidth -g pixelHeight /tmp/sketchybar_art_raw.jpg 2>/dev/null)
W=$(echo "$INFO" | awk '/pixelWidth/{print $2}')
H=$(echo "$INFO" | awk '/pixelHeight/{print $2}')
if [ -z "$W" ] || [ -z "$H" ]; then printf fail; exit 1; fi
# 3. Crop to square from center
if [ "$W" -gt "$H" ]; then
  SIDE=$H; OX=$(( (W - H) / 2 )); OY=0
else
  SIDE=$W; OX=0; OY=$(( (H - W) / 2 ))
fi
sips --cropToHeightWidth $SIDE $SIDE --cropOffset $OY $OX \
  /tmp/sketchybar_art_raw.jpg --out /tmp/sketchybar_art_sq.jpg >/dev/null 2>&1 || { printf fail; exit 1; }
# 4. Resize to 600px (= 300 logical points on 2x Retina)
# 600px × scale 0.5 = 300pt — fills the full popup_width on 2x Retina
sips --resampleHeightWidth 600 600 \
  /tmp/sketchybar_art_sq.jpg --out /tmp/sketchybar_art.jpg >/dev/null 2>&1 || { printf fail; exit 1; }
printf ok
]]

-- ── Events ────────────────────────────────────────────────────────────────
-- media_update is fired by helpers/media_stream.sh (media-control stream)
-- and carries real-time elapsedTime + full track state.
sbar.add("event", "media_update")

-- ── State ──────────────────────────────────────────────────────────────────

local current_state  = "none"   -- "playing" | "paused" | "none"
local popup_open     = false
local last_track_key = ""



-- ── Bar item ───────────────────────────────────────────────────────────────

local media_bar = sbar.add("item", "widgets.media.bar", {
  position    = "right",
  drawing     = false,
  updates     = "on",
  update_freq = 2,
  icon = {
    string = icons.media.music,
    color  = colors.purple,
    font   = { style = settings.font.style_map["Regular"], size = 13 },
  },
  label = {
    string = "—",
    font   = {
      family = settings.font.text,
      style  = settings.font.style_map["Regular"],
      size   = 11,
    },
    color     = colors.white,
    max_chars = 30,
  },
})

local media_bracket = sbar.add("bracket", "widgets.media.bracket",
  { media_bar.name }, {
  background = { color = colors.bg1 },
  popup = {
    horizontal = false,
    align      = "center",
    background = {
      color         = colors.popup.bg,
      border_color  = colors.popup.border,
      border_width  = 1,
      corner_radius = 10,
    },
  },
})

sbar.add("item", "widgets.media.padding", {
  position = "right",
  width    = settings.group_paddings,
})

-- ── Popup ──────────────────────────────────────────────────────────────────

local P = "popup." .. media_bracket.name

-- Row 1: Album art
-- width = popup_width so it fills the full popup horizontally.
-- corner_radius = 10 matches the popup border so the art background doesn't
-- bleed through the popup's rounded top corners.
local popup_art = sbar.add("item", "media.popup.art", {
  position      = P,
  width         = popup_width,
  padding_left  = 0,
  padding_right = 0,
  background = {
    color         = colors.bg2,
    height        = popup_width,  -- square: 300pt × 300pt matches 600px image on 2x
    corner_radius = 0,
    image         = { drawing = false },
  },
  icon = {
    string = icons.media.music,
    color  = colors.with_alpha(colors.purple, 0.35),
    font   = { style = settings.font.style_map["Regular"], size = 40 },
    align  = "center",
    width  = popup_width,
  },
  label = { drawing = false },
})

-- Row 2: Track title
local popup_title = sbar.add("item", "media.popup.title", {
  position = P,
  width    = popup_width,
  align    = "center",
  label = {
    string    = "No track",
    font      = { style = settings.font.style_map["Bold"], size = 13 },
    color     = colors.white,
    max_chars = 28,
  },
})

-- Row 3: Artist · Album
local popup_meta = sbar.add("item", "media.popup.meta", {
  position = P,
  width    = popup_width,
  align    = "center",
  label = {
    string    = "—",
    font      = { size = 10 },
    color     = colors.grey,
    max_chars = 36,
  },
})

-- Row 4: Separator
sbar.add("item", "media.popup.sep1", {
  position      = P,
  width         = popup_width,
  padding_left  = 14,
  padding_right = 14,
  background    = { color = colors.with_alpha(colors.grey, 0.3), height = 1 },
  icon          = { drawing = false },
  label         = { drawing = false },
})

-- Row 5: Play/Pause button centered
local popup_play = sbar.add("item", "media.popup.play", {
  position = P,
  width    = popup_width,
  align    = "center",
  label = {
    string = icons.media.play_pause,
    color  = colors.flash,
    font   = { style = settings.font.style_map["Regular"], size = 26 },
  },
  background   = { height = 36, color = colors.transparent },
  click_script = "media-control toggle-play-pause",
})

-- Row 8: Separator
sbar.add("item", "media.popup.sep2", {
  position      = P,
  width         = popup_width,
  padding_left  = 14,
  padding_right = 14,
  background    = { color = colors.with_alpha(colors.grey, 0.3), height = 1 },
  icon          = { drawing = false },
  label         = { drawing = false },
})

-- Row 9: Progress
-- IMPORTANT: sbar.add("slider", NAME, WIDTH, props) — the string name is
-- required. Without it the returned reference is broken and :set() calls
-- will silently do nothing, which is why elapsed/total weren't updating.
local popup_progress = sbar.add("slider", "media.popup.progress", popup_width - 28, {
  position      = P,
  padding_left  = 14,
  padding_right = 14,
  slider = {
    highlight_color = colors.flash,
    percentage      = 0,
    background = {
      height        = 4,
      corner_radius = 2,
      color         = colors.bg2,
    },
    knob = { string = "•", drawing = true },
  },
  background = { color = colors.transparent, height = 2 },
  icon = {
    string = "0:00",
    font   = { family = settings.font.numbers, size = 10 },
    color  = colors.grey,
    align  = "left",
    width  = 36,
  },
  label = {
    string = "0:00",
    font   = { family = settings.font.numbers, size = 10 },
    color  = colors.grey,
    align  = "right",
  },
})

-- ── Artwork helpers ────────────────────────────────────────────────────────

local function apply_artwork()
  popup_art:set({
    icon = { drawing = false },
    background = {
      color         = colors.transparent,
      height        = popup_width,
      corner_radius = 0,
      image         = { string = ART_PATH, scale = 0.5, drawing = true },
    },
  })
end

local function clear_artwork()
  popup_art:set({
    icon = {
      string  = icons.media.music,
      color   = colors.with_alpha(colors.purple, 0.35),
      drawing = true,
    },
    background = {
      color         = colors.bg2,
      height        = popup_width,
      corner_radius = 0,
      image         = { drawing = false },
    },
  })
end

-- ── Core update ────────────────────────────────────────────────────────────

local function update()
  sbar.exec(GET_CMD, function(result)
    result = (result or ""):gsub("[\n\r]", "")

    -- Stopped / no player
    if result == "none" or result == "" then
      current_state  = "none"
      last_track_key = ""
      media_bar:set({ drawing = false })
      if popup_open then
        popup_open = false
        media_bracket:set({ popup = { drawing = false } })
      end
      return
    end

    local playing_str, rate_str, title, artist, album, dur_str, pos_str =
      result:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)|([^|]*)|([^|]*)|(.*)$")
    if not playing_str then return end

    local rate       = tonumber(rate_str) or 0
    local is_playing = rate > 0
    local dur        = tonumber(dur_str) or 0
    local pos        = tonumber(pos_str) or 0

    local new_key = (artist or "") .. "||" .. (title or "")

    current_state = is_playing and "playing" or "paused"

    local is_active = true   -- hide only when media-control returns nothing
    local dim       = is_playing and 1.0 or 0.5

    -- Bar label: "Artist  ·  Title"
    local bar_label = ((artist or "") ~= "" and (title or "") ~= "")
      and (artist .. "  ·  " .. title)
      or  (title or "—")

    media_bar:set({
      drawing = is_active,
      icon    = { color = colors.with_alpha(colors.purple, dim) },
      label   = { string = bar_label,
                  color  = colors.with_alpha(colors.white, dim) },
    })

    -- Artwork: only fetch on track change
    if new_key ~= last_track_key then
      last_track_key = new_key
      clear_artwork()
      sbar.exec(FETCH_ART_CMD, function(art_result)
        art_result = (art_result or ""):gsub("[\n\r%s]", "")
        if art_result == "ok" then apply_artwork() end
      end)
    end

    -- Popup metadata
    local meta = ((artist or "") ~= "" and (album or "") ~= "")
      and ((artist or "") .. "  ·  " .. (album or ""))
      or  (artist or "")
    popup_title:set({ label = { string = title ~= "" and title or "No track" } })
    popup_meta:set({  label = { string = meta  ~= "" and meta  or "—" } })

    -- Play/pause button brightness reflects state
    popup_play:set({
      label = { color = is_playing and colors.flash
                        or colors.with_alpha(colors.flash, 0.6) },
    })

    -- Progress bar + timestamps
    if dur > 0 then
      popup_progress:set({
        icon   = { string = fmt_time(pos) },
        label  = { string = fmt_time(dur) },
        slider = { percentage = math.floor(pos / dur * 100) },
      })
    end

    -- Auto-close popup when nothing is active
    if not is_active and popup_open then
      popup_open = false
      media_bracket:set({ popup = { drawing = false } })
    end
  end)
end

-- ── Subscriptions ──────────────────────────────────────────────────────────

media_bar:subscribe("routine", update)
media_bar:subscribe("forced",  update)



-- ── Popup toggle ───────────────────────────────────────────────────────────

local function toggle_popup()
  if current_state == "none" then return end
  popup_open = not popup_open
  media_bracket:set({ popup = { drawing = popup_open } })
end

media_bar:subscribe("mouse.clicked", function() toggle_popup() end)

media_bracket:subscribe("mouse.exited.global", function()
  if not popup_open then return end
  popup_open = false
  media_bracket:set({ popup = { drawing = false } })
end)
