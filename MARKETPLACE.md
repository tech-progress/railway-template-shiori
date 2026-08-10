# Deploy and Host Shiori on Railway

## About Hosting Shiori

Shiori saves, searches, tags, imports, and archives bookmarks through a web UI and browser extensions. This template runs the official 1.8.0 binary with generated owner credentials and durable SQLite storage.

## Why Deploy Shiori on Railway

Railway builds a minimal wrapper that replaces Shiori's documented first-boot password before public startup, persists session signing, checks application health, and attaches a 5 GB archive volume.

## Common Use Cases

- Keep a private searchable bookmark library.
- Preserve readable copies and page archives.
- Import bookmarks from browsers or Pocket exports.

## Dependencies for Shiori Hosting

The template uses Shiori, Alpine Linux, and one Railway volume.

### Deployment Dependencies

- [Shiori](https://github.com/go-shiori/shiori) provides bookmark capture, search, archives, and the web UI.
- [Alpine Linux](https://alpinelinux.org) runs the credential bootstrap wrapper around the pinned Shiori binary.
- [Railway](https://railway.com) provides source builds, generated credentials, HTTPS networking, and persistent storage.
