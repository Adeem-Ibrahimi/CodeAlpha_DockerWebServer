FROM nginx:alpine

RUN addgroup -g 1001 -S nginxgroup && adduser -u 1001 -D -S -G nginxgroup nginxuser

COPY index.html /usr/share/nginx/html/index.html

RUN chown -R nginxuser:nginxgroup /var/cache/nginx /var/log/nginx /etc/nginx /usr/share/nginx/html /run

RUN sed -i 's/80;/8080;/g' /etc/nginx/conf.d/default.conf

USER nginxuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
