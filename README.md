# CodeAlpha Docker Web Server

A static web page served from an Nginx container — CodeAlpha DevOps internship, Task 4 (Web Server using Docker).

## What this does
Containerizes a simple static HTML page and demonstrates the full container lifecycle: build, run, monitor, stop, restart, and inspect from inside the container. Runs as a non-root user with an active healthcheck.

## Architecture decisions
- Base image: nginx:alpine — a minimal Linux distro (a few MB vs hundreds), meaning a smaller image, faster pulls, and a smaller attack surface.
- Runs as a dedicated non-root user (nginxuser) rather than root. This required creating the user, handing it ownership of nginx's working directories, and moving the internal listen port from 80 to 8080, since only root can bind ports below 1024.
- Includes a HEALTHCHECK that actually requests the page every 30 seconds using wget (already built into Alpine), so Docker reports real health status instead of just "process is running."

## How to run it
docker build -t codealpha-docker-webserver .
docker run -d -p 8080:8080 --name codealpha-webserver codealpha-docker-webserver

Then visit http://localhost:8080, or run curl localhost:8080.

## Lifecycle / monitoring commands used
docker ps                                  (confirm it's running, check health status)
docker logs codealpha-webserver            (view nginx's own logs)
docker stats --no-stream                   (check CPU/memory usage)
docker exec codealpha-webserver whoami     (confirm it's really running as non-root)
docker stop / start codealpha-webserver
docker exec -it codealpha-webserver sh     (shell inside the container)

## A real challenge I hit
After installing Docker, docker run hello-world failed with "permission denied while trying to connect to the docker API." Only root and members of the docker group can use Docker's socket — fixed by adding my user to that group (sudo usermod -aG docker $USER) and restarting the terminal for it to take effect.

## What I'd change for production
- Add HTTPS/TLS termination — this currently only serves plain HTTP
- Add resource limits (--memory, --cpus) so this container can't consume unbounded host resources
