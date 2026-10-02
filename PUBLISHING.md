# Publishing

The current template release is `v1.0.2`. The application builds `tech-progress/railway-template-shiori` from `release-v1` with root directory `/`; Shiori `1.8.0` is unchanged and the wrapper uses Alpine `3.23.6`.

The Alpine multi-platform digest was checked October 2, 2026 using `docker buildx imagetools inspect alpine:3.23.6`. Refreshing the runtime does not change the upstream binary digest, volume layout, or required environment variables.

Run `bun install --frozen-lockfile`, `bun run verify`, and the clean local image build and smoke. Restart Shiori and rerun with `SHIORI_SKIP_CREATE=1`, then repeat against the source project and exact stored draft. Audit, publish, run the root marketplace sync and audit, and remove every disposable resource.
