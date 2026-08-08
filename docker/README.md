
Database management for VSCode
- https://github.com/mtxr/vscode-sqltools
- https://www.youtube.com/watch?v=_NBk7LtlFJc
  
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

# SQLite

## Init from shema

Having everything consolidated in combined_database.sqlite gives you native foreign keys, instant cross-table joins, and effortless single-file management.

```bash
node init-daelt-db.js
```

## Add some fake data

```bash
node seed-db.js
```

## Dump db

```bash
node dump-db.js
```

```bash
node dump-schema.js
```