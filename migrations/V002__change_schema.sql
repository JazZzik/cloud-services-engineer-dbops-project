-- расширяем таблицу product добавляя колонку price
ALTER TABLE product ADD COLUMN price double precision;

UPDATE product
SET price = product_info.price
FROM product_info
WHERE product.id = product_info.product_id;

DROP TABLE product_info;

-- расширяем таблицу orders добавляя колонку date_created
ALTER TABLE orders ADD COLUMN date_created date;

UPDATE orders
SET
    date_created = orders_date.date_created,
    status = orders_date.status
FROM orders_date
WHERE orders.id = orders_date.order_id;

DROP TABLE orders_date;

-- добавляем первичные ключи
ALTER TABLE product ADD PRIMARY KEY (id);
ALTER TABLE orders ADD PRIMARY KEY (id);

-- добавляем внешние ключи
ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_order
        FOREIGN KEY (order_id) REFERENCES orders (id);

ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_product
        FOREIGN KEY (product_id) REFERENCES product (id);