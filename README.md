### To rebuild clickhouse images from their git src: [link](https://github.com/ClickHouse/ClickHouse.git)
```
docker-compose -f ./build-from-git-src.yml build
```

### To use the available images for arm64 arch at clickhouse  21.11.1.1

* Prerequire:
    * The valid `config.xml` and `users.xml` are mounted at `clickhouse-config` folder
    * User may change the `CLICKHOUSE_UID` and `CLICKHOUSE_GID` in `docker-compose.yml` to their own host machine uid and id by running these command below
        * echo "CLICKHOUSE_UID=$(id -u)"
        * echo "CLICKHOUSE_GID=$(id -g)"

* Run single node of Clickhouse on arm64

```
docker-compose -f ./docker-compose.yml up -d
```

* Check if container is loaded OK

```
echo 'SELECT version()' | curl 'http://localhost:8123/' --data-binary @-
```