ARG DBT_VERSION=1.0.0
FROM fishtownanalytics/dbt:${DBT_VERSION}


# Install utils
RUN apt -y update \
    && apt -y upgrade \
    && apt -y install curl wget gpg unzip

# Install dbt adapter
RUN set -ex \
    && python -m pip install --upgrade pip setuptools \
    && python -m pip install dbt-postgres

WORKDIR /usr/app/
ENV DBT_PROFILES_DIR=.

ENTRYPOINT ["tail", "-f", "/dev/null"]