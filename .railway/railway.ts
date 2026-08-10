import { defineRailway, github, group, project, service, volume } from "railway/iac";

const SOURCE = github("tech-progress/railway-template-shiori", { branch: "release-v1", rootDirectory: "/" });

export default defineRailway((ctx) => {
  const password = ctx.randomString("shiori-owner-password", 32);
  const httpSecret = ctx.randomString("shiori-http-secret", 48);
  const data = volume("Shiori Data", { sizeMB: 5_000 });
  const shiori = service("Shiori", {
    source: SOURCE,
    build: { builder: "DOCKERFILE", dockerfilePath: "Dockerfile", watchPatterns: ["/Dockerfile", "/railway-entrypoint.sh"] },
    healthcheck: "/",
    healthcheckTimeout: 300,
    volumeMounts: { "/shiori": data },
    env: { PORT: "8080", SHIORI_DIR: "/shiori", SHIORI_HTTP_SECRET_KEY: httpSecret, SHIORI_USERNAME: "owner", SHIORI_PASSWORD: password },
  });
  return project("Shiori bookmarks", { resources: [group("Bookmarks", [shiori, data])] });
});
