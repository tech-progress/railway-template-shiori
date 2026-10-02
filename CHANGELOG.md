# Changelog

## 1.0.2 - 2026-10-02

- Retain Shiori 1.8.0 and refresh the Alpine runtime to 3.23.6 with a registry-verified immutable digest.
- Correct the shared template audit to expect the standalone repository on release-v1 with root directory /.

## 1.0.1 - 2026-08-10

- Remove the Dockerfile `VOLUME` declaration because Railway rejects it; the template still attaches its managed volume at `/shiori`.

## 1.0.0 - 2026-08-10

- Initial Railway template for protected, persistent Shiori bookmarks.
