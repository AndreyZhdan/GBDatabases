�������� ���� ������ example, ���������� � ��� ������� users, ���������
-- �� ���� ��������, ��������� id � ���������� name.
CREATE DATABASE example;
USE example;

CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  name VARCHAR(255) NOT NULL UNIQUE
);

-- ������� 3
-- �������� ���� ���� ������ example �� ����������� �������, ����������
-- ���������� ����� � ����� ���� ������ sample.

-- ������ ���� �� example
mysqldump example > example.sql

-- ������ �� sample
mysql -e 'CREATE DATABASE sample'

-- ��������� ���� � �� sample
mysql sample < example.sql

-- ������� 4
-- (�� �������) ������������ ����� �������� � ������������� �������
-- mysqldump. �������� ���� ������������ ������� help_keyword ���� ������
-- mysql. ������ ��������� ����, ����� ���� �������� ������ ������ 100
-- ����� �������.

mysqldump mysql help_keyword --where='TRUE LIMIT 100' > help_keyword_report.sql