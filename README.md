# scrapyd docker #


1. default settings provided.
2. aliyun mirror used for apt install.
3. douban mirror used for pypi.


Example of `docker-compose.yml`:

    version: '3'

    services:

      scrapyd:
        image: caky/scrapyd
        restart: always
        volumes:
          - /data/scrapyd:/app
        ports:
          - 6800:6800
        networks:
          - default

      scrapydweb:
        image: caky/scrapydweb
        restart: always
        depends_on:
          - scrapyd
        volumes:
          - /data/scrapydweb:/app/data
          - /data/scrapy_projects:/app/scrapy_projects
        ports:
          - 8085:5000
        networks:
          - default
        environment:
          DATA_PATH: "/app/data"
          SCRAPYDWEB_USER: ${SCRAPYDWEB_USER}
          SCRAPYDWEB_PASSWORD: ${SCRAPYDWEB_PASSWORD}
          TZ : "Asia/Shanghai"

      redis:
        image: bitnami/redis:latest
        restart: always
        ports:
          - 10451:6379   # TODO: only for debug
        networks:
          - default
        environment:
          REDIS_PASSWORD: ${REDIS_PASSWORD}
          DISABLE_COMMANDS: FLUSHDB,FLUSHALL,CONFIG
          TZ : "Asia/Shanghai"

      pg:
        image: bitnami/postgresql:latest
        restart: unless-stopped
        ports:
          - 10402:5432      # serving external clients
        volumes:
          - /data/spiderman/pg:/bitnami/postgresql
          - ./pg_init.sh:/docker-entrypoint-initdb.d/pg_init.sh
        networks:
          - default
        environment:
          POSTGRESQL_USERNAME: ${PG_USER}
          POSTGRESQL_PASSWORD: ${PG_PASSWORD}
          POSTGRESQL_DATABASE: ${PG_DB}
          POSTGRESQL_POSTGRES_PASSWORD: ${PG_ADMIN_PASSWORD}
          TZ : "Asia/Shanghai"
          # BITNAMI_DEBUG: "true"

      adminer:
        image: adminer:4.7
        restart: always
        ports:
          - 8084:8080
        networks:
          - default

      networks:
        default:
          driver: bridge
