-- 1. ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. 
-- «аполните их текущими датой и временем.


UPDATE users
	SET created_at = NOW() AND updated_at = NOW()
;

-- 2. “аблица users была неудачно спроектирована. «аписи created_at и updated_at были заданы
--    типом VARCHAR и в них долгое врем€ помещались значени€ в формате "20.10.2017 8:10".
--    Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€.

-- заменим формат

update users
	set created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'),
		updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i');
		
-- изменим тип данных
	
ALTER TABLE users 
	CHANGE created_at created_at DATETIME DEFAULT NOW();
	
ALTER TABLE users 
	CHANGE updated_at updated_at DATETIME DEFAULT NOW() ON UPDATE NOW();
	
/*«адание 3. ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 
 * 0, если товар закончилс€ и выше нул€, если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким образом,
 * чтобы они выводились в пор€дке увеличени€ значени€ value. ќднако, нулевые запасы должны выводитьс€ в конце, после
 * всех записей.*/

-- создадим таблицу

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id serial PRIMARY KEY,
	value INT UNSIGNED
);

-- заполним ее
INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 1, 2, now(), now()),
	(2, 2, 1, now(), now()),
	(3, 3, 5, now(), now()),
	(4, 4, 0, now(), now()),
	(5, 5, 4, now(), now()),
	(6, 6, 3, now(), now())
;

-- отсортируем

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 999999 ELSE value END;



-- 4. (по желанию) »з таблицы users необходимо извлечь пользователей, родившихс€ в августе и мае.
-- ћес€цы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users WHERE birthday_at RLIKE '^[0-9]{4}-(05|08)-[0-9]{2}';

-- 5. (по желанию) »з таблицы catalogs извлекаютс€ записи при помощи запроса:
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); ќтсортируйте записи в пор€дке, заданном в списке IN.


SELECT * FROM catalogs WHERE id IN (5, 1, 2) 
ORDER BY CASE
    WHEN id = 5 THEN 0
    WHEN id = 1 THEN 1
    WHEN id = 2 THEN 2
END;

