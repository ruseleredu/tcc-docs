
## Start

```bash
docker compose up -d
```

## Stop

```bash
docker compose down -v
```

## Fix PMA TempDir

```bash
docker exec -it phpmyadmin mkdir -p /app/www/public/tmp
docker exec -it phpmyadmin chmod 777 /app/www/public/tmp
```

## Dump data
```bash
docker exec -it mariadb mariadb-dump -u root -p"rootpassword" --no-data tcc > tcc-schema.sql
```

```bash
docker exec -it mariadb mariadb-dump -u root -p"rootpassword" --no-data daelt > daelt-schema.sql
```