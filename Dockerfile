FROM nginxinc/nginx-unprivileged:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
USER nginx
HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
