FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings \
    ENABLED_COLLECTIONS="rh-python36 rh-postgresql12"

RUN yum -y install centos-release-scl-rh \
    && yum -y install \
        gcc \
        git \
        rh-python36 \
        rh-postgresql12-postgresql-libs \
        rh-postgresql12-postgresql-devel \
    && yum -y clean all

COPY constraints.txt requirements.txt /tmp/pulp/
RUN source scl_source enable ${ENABLED_COLLECTIONS} \
    && python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip install --no-cache-dir -U \
        'pip>=20.0,<21.0' \
    && pip install --no-cache-dir \
        -c /tmp/pulp/constraints.txt \
        -r /tmp/pulp/requirements.txt

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY settings.py /etc/pulp/settings.py
COPY entrypoint.sh /entrypoint

RUN useradd --uid 1000 \
        --no-create-home \
        --user-group django \
    && mkdir -p -m 0775 /var/run/pulp \
                     /var/lib/pulp/tmp \
    && chown django:root /entrypoint \
                         /var/run/pulp \
                         /var/lib/pulp/tmp \
    && chmod +x /entrypoint

USER django
VOLUME /data/
WORKDIR /code/
ENTRYPOINT [ "/entrypoint" ]
