FROM registry.access.redhat.com/ubi8/nginx-118:latest

USER 0
RUN mkdir -p -m 0770 /var/cache/nginx \
    && chown 1001:0 /var/cache/nginx
USER 1001

COPY nginx/nginx.conf "${NGINX_CONF_PATH}"
COPY nginx/nginx-cfg/default.conf "${NGINX_CONFIGURATION_PATH}"

CMD nginx -g "daemon off;"
