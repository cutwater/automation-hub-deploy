FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings \
    PATH="/venv/bin:$PATH"

RUN yum -y install epel-release \
    && yum -y install \
        gcc \
        git \
        python36 \
        python36-devel \
    && yum -y clean all

COPY requirements.txt /tmp/pulp/
RUN python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        'pip<19.0' \
        wheel \
        uwsgi \
    && cd /tmp/pulp \
    && pip install -r requirements.txt

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

VOLUME /data/
WORKDIR /code/
USER django

ENTRYPOINT [ "/entrypoint" ]
