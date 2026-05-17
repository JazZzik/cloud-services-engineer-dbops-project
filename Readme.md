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

## Продажи сосисок за последие 7 дней (Шаг 10)

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    o.date_created,
    SUM(op.quantity)
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped'
  AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY o.date_created
ORDER BY o.date_created;
```

```sh
 date_created |  sum   
--------------+--------
 2026-05-11   | 939822
 2026-05-12   | 947627
 2026-05-13   | 941288
 2026-05-14   | 942742
 2026-05-15   | 940291
 2026-05-16   | 949447
 2026-05-17   | 891213
(7 rows)

Time: 1739.768 ms (00:01.740)
```

```sh
Finalize GroupAggregate  (cost=266199.81..266222.87 rows=91 width=12) (actual time=2203.821..2210.727 rows=7 loops=1)
   Group Key: o.date_created
   Buffers: shared hit=13698 read=113732
   ->  Gather Merge  (cost=266199.81..266221.05 rows=182 width=12) (actual time=2203.792..2210.695 rows=21 
loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=13698 read=113732
         ->  Sort  (cost=265199.79..265200.02 rows=91 width=12) (actual time=2171.630..2171.634 rows=7 loops=3)
               Sort Key: o.date_created
               Sort Method: quicksort  Memory: 25kB
               Buffers: shared hit=13698 read=113732
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Partial HashAggregate  (cost=265195.92..265196.83 rows=91 width=12) (actual time=2171.608..2171.613 rows=7 loops=3)
                     Group Key: o.date_created
                     Batches: 1  Memory Usage: 24kB
                     Buffers: shared hit=13682 read=113732
                     Worker 0:  Batches: 1  Memory Usage: 24kB
                     Worker 1:  Batches: 1  Memory Usage: 24kB
                     ->  Parallel Hash Join  (cost=148363.10..264661.58 rows=106867 width=8) (actual time=757.654..2149.907 rows=85670 loops=3)
                           Hash Cond: (op.order_id = o.id)
                           Buffers: shared hit=13682 read=113732
                           ->  Parallel Seq Scan on order_product op  (cost=0.00..105361.13 rows=4166613 width=12) (actual time=0.025..375.544 rows=3333333 loops=3)
                                 Buffers: shared hit=6806 read=56889
                           ->  Parallel Hash  (cost=147027.26..147027.26 rows=106867 width=12) (actual time=756.322..756.323 rows=85670 loops=3)
                                 Buckets: 262144  Batches: 1  Memory Usage: 14144kB
                                 Buffers: shared hit=6852 read=56843
                                 ->  Parallel Seq Scan on orders o  (cost=0.00..147027.26 rows=106867 width=12) (actual time=13.190..710.687 rows=85670 loops=3)
                                       Filter: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                                       Rows Removed by Filter: 3247664
                                       Buffers: shared hit=6852 read=56843
 Planning:
   Buffers: shared hit=8
 Planning Time: 0.205 ms
 JIT:
   Functions: 54
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 2.394 ms, Inlining 0.000 ms, Optimization 3.059 ms, Emission 36.547 ms, Total 42.000 ms
 Execution Time: 2211.757 ms
```

