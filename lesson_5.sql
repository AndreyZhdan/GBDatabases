-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. 
-- ��������� �� �������� ����� � ��������.


UPDATE users
	SET created_at = NOW() AND updated_at = NOW()
;

-- 2. ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������
--    ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� "20.10.2017 8:10".
--    ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

-- ������� ������

update users
	set created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'),
		updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i');
		
-- ������� ��� ������
	
ALTER TABLE users 
	CHANGE created_at created_at DATETIME DEFAULT NOW();
	
ALTER TABLE users 
	CHANGE updated_at updated_at DATETIME DEFAULT NOW() ON UPDATE NOW();
	
/*������� 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 
 * 0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������,
 * ����� ��� ���������� � ������� ���������� �������� value. ������, ������� ������ ������ ���������� � �����, �����
 * ���� �������.*/

-- �������� �������

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id serial PRIMARY KEY,
	value INT UNSIGNED
);

-- �������� ��
INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 1, 2, now(), now()),
	(2, 2, 1, now(), now()),
	(3, 3, 5, now(), now()),
	(4, 4, 0, now(), now()),
	(5, 5, 4, now(), now()),
	(6, 6, 3, now(), now())
;

-- �����������

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 999999 ELSE value END;



-- 4. (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���.
-- ������ ������ � ���� ������ ���������� �������� ('may', 'august')

SELECT * FROM users WHERE birthday_at RLIKE '^[0-9]{4}-(05|08)-[0-9]{2}';

-- 5. (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������:
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.


SELECT * FROM catalogs WHERE id IN (5, 1, 2) 
ORDER BY CASE
    WHEN id = 5 THEN 0
    WHEN id = 1 THEN 1
    WHEN id = 2 THEN 2
END;

