# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

## Создание БД `store` (шаги 1-6)

```sh
store_default=# CREATE DATABASE store;
CREATE DATABASE
store_default=# CREATE USER store_user WITH PASSWORD 'store_user';
CREATE ROLE
store_default=# GRANT ALL PRIVILEGES ON DATABASE store TO store_user;
GRANT

store_default=# \c store
psql (16.13 (Ubuntu 16.13-0ubuntu0.24.04.1), server 16.14 (Debian 16.14-1.pgdg13+1))
You are now connected to database "store" as user "user".
store=# GRANT ALL PRIVILEGES ON SCHEMA public TO store_user;
GRANT
store=# GRANT CREATE ON SCHEMA public TO store_user;
GRANT
store=# ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO store_user;
ALTER DEFAULT PRIVILEGES
store=# ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO store_user;
ALTER DEFAULT PRIVILEGES
```
