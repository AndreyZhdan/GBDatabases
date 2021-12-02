-- ƒќЅј¬Ћ≈Ќџ “јЅƒ»÷џ "«ј Ћјƒ »"Ѕ "ќЅЏя¬Ћ≈Ќ»я" » " ј“≈√ќ–»»" ƒЋя "ќЅЏя¬Ћ≈Ќ»я"
-- ¬ “јЅЋ»÷” `photos` ƒќЅј¬Ћ≈Ќј —“–ќ ј title VARCHAR(55) NOT null
-- — ÷≈Ћ№ё ќЅ≈—ѕ≈„»“№ ¬ќ«ћќ∆Ќќ—“№ ѕќ»— ј ѕќ Ќј«¬јЌ»ё INDEX photos_title_idx(title)

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT '‘амили€', -- COMMENT на случай, если им€ неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'),
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзь€
ALTER TABLE friend_requests 
ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое им€ (communities_name_idx)
	foreign key (admin_user_id) references users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file blob,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) Ц можно было и так вместо id в качестве PK
  	-- слишком увлекатьс€ индексами тоже опасно, рациональнее их добавл€ть по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL,
	title VARCHAR(55) NOT null
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	INDEX photos_title_idx(title)
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

-- “аблица дл€ базы «ј Ћјƒ »

DROP TABLE IF EXISTS bookmarks;
CREATE TABLE bookmarks(
	post_id BIGINT UNSIGNED NOT NULL UNIQUE,
	user_id BIGINT UNSIGNED NOT NULL,
	body text,
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
);

-- “аблица дл€ базы  ј“≈√ќ–»я дл€ ќЅЏя¬Ћ≈Ќ»я
DROP TABLE IF EXISTS category;
CREATE TABLE category(
	id SERIAL,
	title VARCHAR(55) NOT null,
	description_ads TEXT,
);
    
    -- “аблица дл€ базы ќЅЏя¬Ћ≈Ќ»я

DROP TABLE IF EXISTS ads;
CREATE TABLE ads(
	id SERIAL,
	ads_user_id BIGINT UNSIGNED NOT NULL,
	category_id BIGINT UNSIGNED NOT NULL UNIQUE,
	price DECIMAL (9,2) NOT NULL,
	type_category VARCHAR(55) NOT null,
	description_ads TEXT,
	photo_ads BIGINT UNSIGNED NOT NULL,
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	INDEX ads_type_category_idx(type_category)
    FOREIGN KEY (ads_user_id) REFERENCES users(id),
	FOREIGN KEY (category_id) REFERENCES category(id),
	FOREIGN KEY (photo_ads) REFERENCES media(id),
);
