# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI Hub is a system for centralized AI chat interactions. It lets users send prompts from a single web UI and routes them through a browser extension to AI platforms (currently ChatGPT). The project lives under the parent `Hubassis/` directory with two subdirectories:

- **`ai-hub/`** — The main application (server + web frontend + Chrome extension)
- **`nwjs-webview/`** — An NW.js prototype with tabbed webviews for Claude, Gemini, and Grok (standalone, not connected to ai-hub)

## Commands

### ai-hub server
```bash
cd ai-hub
npm install
npm run dev          # Start with --watch (auto-reload on changes)
npm start            # Start without watch
```
Server runs on `http://localhost:3000` by default (configurable via `PORT` env var).

### nwjs-webview (NW.js prototype)
```bash
cd nwjs-webview
npm install
npm start            # Launches NW.js desktop window
```

## Architecture (ai-hub)

The system has three communicating components connected via WebSocket:

```
Web Frontend  <--WS-->  Node Server  <--WS-->  Chrome Extension  -->  ChatGPT DOM
```

### Message Flow
1. User types a prompt in the **web frontend** (`web/app.js`)
2. Frontend sends a `prompt` message over WebSocket to the **server**
3. Server (`server/websocket/handler.js`) saves the user message to SQLite, then forwards as `prompt:forward` to the **extension**
4. Extension's **background script** (`extension/background.js`) finds/opens a ChatGPT tab and relays to the **content script**
5. Content script (`extension/content/openai.js`) injects the prompt into ChatGPT's DOM via `OpenAIAdapter`, waits for the response, extracts it
6. Response flows back: content script → background → server (saves to DB) → frontend

### Shared Protocol
`shared/messageTypes.js` defines `MESSAGE_TYPES`, `CLIENT_TYPES`, and `STATUS` constants. This file is loaded both server-side (CommonJS) and client-side (via `<script>` tag served at `/shared/`).

### WebSocket Client Types
The server tracks two client pools: `frontend` and `extension`. Clients self-identify via a `register` message on connection. Status updates (sending, waiting, extracting, done, error) are forwarded from extension to frontend.

### Database
SQLite via `better-sqlite3` with WAL mode. Schema in `server/db/schema.sql`: `conversations` and `messages` tables. DB file is `server/db/hub.db` (gitignored). Auto-titles conversations from the first user message (truncated to 80 chars).

### Chrome Extension (Manifest V3)
- `background.js`: Service worker that maintains a WebSocket to the server, handles prompt forwarding, manages ChatGPT tab lifecycle. Uses `chrome.alarms` for keepalive.
- `content/adapterBase.js`: Abstract base class for AI platform adapters (defines `sendPrompt`, `waitForResponse` interface).
- `content/openai.js`: ChatGPT-specific adapter using DOM selectors (`#prompt-textarea`, `[data-testid="send-button"]`, etc.). Detects response completion by watching the stop button.
- `utils/domHelpers.js`: `waitForElement` (MutationObserver-based), `simulateInput` (handles both contenteditable and textarea), `extractTextContent`.

### Adding a New AI Platform Adapter
1. Create `extension/content/<platform>.js` extending `AdapterBase`
2. Implement `getTextareaSelector()`, `getSendButtonSelector()`, `getResponseSelector()`, `waitForResponse()`
3. Add host permissions and content script entry in `extension/manifest.json`
4. Handle the new platform value in the server's response handler

## UI Language
The interface is in Spanish (labels, status messages, alerts).
