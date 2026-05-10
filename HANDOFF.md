# Sherry Content Board — Windsurf Handoff

## Context

The project was rebuilt from scratch as a single `index.html` file.
All previous code is replaced by this file. Do not reference or restore old code.
This document is your source of truth for the current architecture.

---

## File Structure

```
index.html   ← entire application (HTML + CSS + JS, no build step)
```

No package.json, no node_modules, no bundler. Open the file directly in a browser or deploy it as-is to any static host (Netlify, S3, GitHub Pages, etc.).

---

## Tech Stack

| Concern       | Solution                                              |
|---------------|-------------------------------------------------------|
| Frontend      | Vanilla JS (ES6+), HTML5, CSS3                        |
| Supabase SDK  | Loaded via CDN: `cdn.jsdelivr.net/npm/@supabase/supabase-js@2` |
| Fonts         | Google Fonts CDN — Playfair Display + DM Mono         |
| Build tooling | None                                                  |

---

## Supabase Configuration

Credentials are hardcoded near the top of the `<script>` block:

```js
const sb = createClient(
  'https://gyavdaefgzmsuvtufzfr.supabase.co',
  '<anon_key>'
);
```

**Do not move these into a `.env` file** — this is a static file with no build step. The anon key is safe to expose (it's protected by Supabase Row Level Security).

---

## Database Schema

### `videos`
| Column       | Type        | Notes                        |
|--------------|-------------|------------------------------|
| `id`         | integer PK  | Auto-generated               |
| `num`        | integer     | Display number (nullable)    |
| `title`      | text        | Required                     |
| `url`        | text        | YouTube or Cloudinary URL    |
| `category`   | text        | One of the 6 fixed categories|
| `views`      | text        | Free text e.g. "1.2K"        |
| `created_at` | timestamp   | Default NOW()                |
| `updated_at` | timestamp   | Updated on every write       |

### `shots`
| Column       | Type        | Notes                                      |
|--------------|-------------|--------------------------------------------|
| `id`         | serial PK   |                                            |
| `video_id`   | integer FK  | References `videos.id` ON DELETE CASCADE   |
| `list`       | text[]      | Array of shot description strings          |
| `count`      | integer     | Mirrors `list.length` — kept in sync       |
| `created_at` | timestamp   |                                            |
| `updated_at` | timestamp   |                                            |

**Important:** `shots.list` is a native Postgres `text[]` array. The JS code reads and writes it as a plain JS array (`string[]`). Supabase handles the serialisation automatically. Do not stringify it manually.

---

## JavaScript Architecture

All JS lives in a single `<script>` block at the bottom of `index.html`.
There are no classes — the app uses module-level variables and plain functions.

### State

```js
let videos = [];        // array of video row objects from Supabase
let shots  = {};        // object keyed by video_id → shot row object
let activeCat = 'all';  // currently selected category filter
```

### Boot sequence

```
loadAll()
  → parallel: sb.from('videos').select + sb.from('shots').select
  → populates videos[] and shots{}
  → buildCats()   — builds category filter pills
  → render()      — renders the card grid
```

### Key functions

| Function              | What it does                                              |
|-----------------------|-----------------------------------------------------------|
| `loadAll()`           | Fetches all videos + shots from Supabase on page load     |
| `render()`            | Filters videos by search + category, rebuilds the grid    |
| `buildCats()`         | Rebuilds category pill buttons from current `videos[]`    |
| `setCat(btn)`         | Sets `activeCat`, updates pill state, calls `render()`    |
| `cardHTML(v)`         | Returns full card HTML string for one video               |
| `shotRowHTML(vid,val,idx)` | Returns one shot row HTML string                    |
| `addShot(vid)`        | Appends empty string to shot list, persists, re-focuses   |
| `delShot(vid, idx)`   | Removes shot at index, persists                           |
| `saveShot(vid,idx,val)` | Updates shot value at index on blur/Enter, persists     |
| `writeShots(vid,list)` | Upserts the shots row to Supabase, patches DOM in-place  |
| `openModal(id?)`      | Opens add (no arg) or edit (with id) modal                |
| `closeModal()`        | Closes modal, resets `editId`                             |
| `saveVideo()`         | Validates form, inserts or updates video in Supabase      |
| `confirmDel(id)`      | Opens confirmation dialog                                 |
| `doDelete()`          | Deletes video from Supabase, removes from local state     |
| `thumb(url)`          | Derives thumbnail URL from YouTube or Cloudinary URL      |
| `esc(s)`              | HTML-escapes a string (used in all template literals)     |
| `toast(msg, err?)`    | Shows bottom-right notification toast                     |

### DOM patching strategy

Shots are updated **in-place** without re-rendering the whole grid:

```js
// After writeShots(), only these two elements are replaced:
document.getElementById(`sl-${vid}`)   // the shots list UL
document.getElementById(`sc-${vid}`)   // the shot count badge
```

Full `render()` is only called after: initial load, add/edit/delete video, category or search filter change.

---

## Categories

Fixed list — not stored in the database, hardcoded in two places:

1. `CAT_ORDER` array in JS (controls display order in filter bar)
2. `<select id="fCat">` options in the modal HTML

If you add a new category, update **both** places.

```js
const CAT_ORDER = ['Thuis','Feria','Tussendoor','Veel werk','Tsja','Klaar'];
```

---

## Thumbnail Logic (`thumb(url)`)

| URL type              | Strategy                                                  |
|-----------------------|-----------------------------------------------------------|
| YouTube (any format)  | Extracts video ID, returns `img.youtube.com/vi/{id}/hqdefault.jpg` |
| Cloudinary video      | Transforms upload URL to poster frame via `so_auto,w_480,f_jpg` |
| Cloudinary image      | Adds `w_480,c_fill` transform                             |
| Anything else         | Returns `null` → shows `▣` placeholder                   |

---

## CSS Architecture

All CSS is in a `<style>` block in `<head>`. It uses CSS custom properties (variables) defined on `:root`:

```css
:root {
  --bg, --surface, --surface-2, --surface-3   /* dark backgrounds */
  --border, --border-2                         /* border tones */
  --gold, --gold-lt, --gold-dim               /* primary accent */
  --orange                                     /* secondary accent */
  --text, --text-2, --text-3                  /* text hierarchy */
  --danger                                     /* destructive actions */
  --radius                                     /* border radius */
}
```

**Grid breakpoints:**
- `< 640px`  → 2 columns (mobile)
- `≥ 900px`  → 3 columns (tablet)
- `≥ 1280px` → 4 columns (desktop)

---

## What Was Intentionally Left Out

These items from the original plan were deferred to keep the file clean and working:

- **Realtime subscriptions** — not implemented; reload the page to sync changes from other sessions
- **Lazy loading / virtual scroll** — not needed at current scale
- **Search debounce** — fires on every keystroke; add `debounce()` if performance becomes an issue
- **WCAG / accessibility pass** — basic semantics in place, full audit not done

---

## How to Extend

**Add a field to videos:** add a column in Supabase → add an `<input>` in the modal HTML (inside `.modal-body`) → include the field in the `payload` object inside `saveVideo()` → display it in `cardHTML()`.

**Add a new category:** add the string to `CAT_ORDER` in JS and add an `<option>` to `#fCat` in the modal.

**Change the colour scheme:** edit the CSS variables in `:root`. Every colour in the UI derives from those variables.

**Split into multiple files:** if this file grows beyond ~600 lines, extract the `<style>` block to `styles.css` and the `<script>` block to `app.js` and link them from the HTML. No other changes needed — there's no module system to wire up.
