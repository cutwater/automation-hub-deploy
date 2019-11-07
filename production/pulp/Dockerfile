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

RUN mkdir -p /var/run/pulp \
    /var/lib/pulp/tmp

COPY requirements.txt /tmp/pulp/
COPY pulp-ansible /code/pulp-ansible

RUN python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        'pip<19.0' \
        wheel \
        uwsgi \
    && cd /tmp/pulp \
    && pip install -r requirements.txt \
    && pip install -e /code/pulp-ansible

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY entrypoint.sh /entrypoint
COPY settings.py /etc/pulp/settings.py

RUN useradd --no-create-home --user-group django \
    && chmod +x /entrypoint \
    && chown django /entrypoint \
    && chown django:root /var/run/pulp \
                         /var/lib/pulp/tmp \
    && chmod g+w /var/run/pulp \
                 /var/lib/pulp/tmp

VOLUME /data/
WORKDIR /code/
USER django

ENTRYPOINT [ "/entrypoint" ]
