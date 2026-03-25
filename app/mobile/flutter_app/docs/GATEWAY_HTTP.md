# OpenClaw Gateway (HTTP)

PocketClaw can send **chat** through a running OpenClaw **Gateway** using its OpenAI-compatible HTTP API (see [Gateway Runbook](https://docs.openclaw.ai/gateway)).

## Configure in the app

**Settings → OpenClaw Gateway**

1. Turn on **Use gateway for chat**.
2. Set **Gateway base URL** — e.g. `http://127.0.0.1:18789` (default gateway port) or `http://<lan-ip>:18789` for a machine on your network.
3. Paste the **operator token** (same trust boundary as `gateway.auth.token` in gateway config). **Save gateway settings**.
4. Optional: **Test connection** — performs `GET /v1/models` with `Authorization: Bearer <token>`.

When enabled and both URL + token are present, **chat uses the gateway** (including SSE streaming) and **takes priority** over direct `api.openai.com` via OpenAI API key / OAuth.

## Android HTTP (LAN)

The debug/release manifest allows **cleartext HTTP** so you can reach a gateway on your LAN without TLS during development. Prefer HTTPS or VPN (e.g. Tailscale) for real deployments.

## WebSocket (control plane)

**Settings → Test WebSocket (hello-ok)** runs a **real** handshake against the gateway:

1. Optional `connect.challenge` (nonce).
2. `connect` request with **protocol 3**, operator scopes, `auth.token`, and **Ed25519** device identity (persistent key in secure storage, **v3** signing payload aligned with OpenClaw).
3. Waits for `res` → `hello-ok` (server version, protocol, optional snapshot).

This is **not** used for chat yet (chat stays on HTTP `/v1/chat/completions`); it proves the app can join the same WebSocket control plane as the official clients.

## Not implemented here

- Ongoing WebSocket session (RPC, chat events, reconnect) — handshake only.
- Bundling OpenClaw/Node on-device — separate Android spike.
