<img src="icon.svg" width="56" height="56" alt="MyPlanner icon">

# MyPlanner

A single-file personal planner that runs entirely in your browser — no server, no account, no build step. Just open `planner.html`.

## Features

- **Categories**: Websites, Books, Emails & Contacts, Ideas & Notes, plus your own custom categories (drag to reorder, rename, delete)
- **Reminders**: dates, times, and recurrence (daily/weekly/monthly/yearly), with a Week/Month/Year calendar view
- **Home dashboard**: quick actions, live stats, pinned notes, upcoming reminders (next 5 days), and a "Recent" horizontal card row per category
- **Email alerts**: opens a pre-filled `mailto:` draft for a single reminder or all of them at once — no external service required
- **Favorites, Pin, Paid, Amount** fields for tracking bills/installments
- **Trash**: soft-delete with 30-day auto-purge and restore
- **Export/Import**: full JSON backup, plus `.ics` calendar export for Google Calendar/Outlook/Apple Calendar
- **Dark mode**, drag-and-drop item categorization, and a mobile-friendly bottom nav

## Getting started

1. Download `planner.html`.
2. Open it in any modern browser (double-click, or drag it into a browser window).
3. Your data is saved locally in that browser via `localStorage` — nothing leaves your machine.

See [`manual.html`](manual.html) for the full user manual (with a read-aloud feature).

## Data & privacy

All data stays in your browser's local storage. Clearing your browser's site data for local files will erase it — use **Settings → Export** or **Backup** regularly to keep a copy.

## Tech

Plain HTML/CSS/JavaScript, zero dependencies, zero build step.
