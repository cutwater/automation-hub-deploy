FROM registry.access.redhat.com/ubi8/nginx-118:latest

USER 0
RUN mkdir -p -m 0770 /var/cache/nginx \
    && chown 1001:0 /var/cache/nginx
USER 1001

COPY --chown=1001:0 nginx/nginx.conf "${NGINX_CONF_PATH}"
COPY --chown=1001:0 nginx/nginx-cfg/default.conf "${NGINX_CONFIGURATION_PATH}"
COPY --chown=1001:0 run.sh /run.sh

RUN chmod -R a+rwX \
    "${NGINX_CONF_PATH}" \
    "${NGINX_CONFIGURATION_PATH}"

CMD [ "/run.sh" ]
