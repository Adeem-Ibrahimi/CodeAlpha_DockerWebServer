# CodeAlpha Docker Web Server

A static web page served from an Nginx container — CodeAlpha DevOps internship, Task 4 (Web Server using Docker).

## What this does
Containerizes a simple static HTML page and demonstrates the full container lifecycle: build, run, monitor, stop, restart, and inspect from inside the container.

## Architecture decisions
- **Base image: nginx:alpine** — Alpine is a minimal Linux distro (a few MB vs hundreds), meaning a smaller image, faster pulls, and a smaller attack surface. No need for a full OS just to serve one static file.
- **No custom Nginx config written** — the base image's default config already serves index.html from /usr/share/nginx/html, so the only work needed was copying the file into that existing path.
- **Port mapping -p 8080:80** — avoids conflicts and permission quirks some systems have with privileged low ports on the host side.

## How to run it
docker build -t codealpha-docker-webserver .
docker run -d -p 8080:80 --name codealpha-webserver codealpha-docker-webserver

Then visit http://localhost:8080, or run curl localhost:8080.

## Lifecycle / monitoring commands used
docker ps                              (confirm it's running)
docker logs codealpha-webserver        (view nginx's own logs)
docker stats --no-stream               (check CPU/memory usage)
docker stop / start codealpha-webserver
docker exec -it codealpha-webserver sh (shell inside the container)

## A real challenge I hit
After installing Docker, docker run hello-world failed with "permission denied while trying to connect to the docker API." Only root and members of the docker group can use Docker's socket — fixed by adding my user to that group (sudo usermod -aG docker $USER) and restarting the terminal for it to take effect.

## What I'd change for production
- Run as a non-root user inside the container
- Add a HEALTHCHECK instruction so orchestration tools can detect if the server stops responding
- Add HTTPS/TLS termination — this currently only serves plain HTTP
