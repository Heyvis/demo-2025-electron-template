CREATE TABLE
	PARTNERS (
		ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		ORGANIZATION_TYPE CHARACTER VARYING(3),
		NAME TEXT UNIQUE,
		CEO TEXT,
		EMAIL CHARACTER VARYING(50),
		PHONE CHARACTER VARYING(15),
		ADDRESS TEXT,
		TAXPAYER_ID CHARACTER VARYING(15),
		RATING INT
	);

INSERT INTO
	PARTNERS (
		ORGANIZATION_TYPE,
		NAME,
		CEO,
		EMAIL,
		PHONE,
		ADDRESS,
		TAXPAYER_ID,
		RATING
	)
VALUES
	(
		'ЗАО',
		'База Строитель',
		'Иванова Александра Ивановна',
		'aleksandraivanova@ml.ru',
		'493 123 45 67',
		'652050, Кемеровская область, город Юрга, ул. Лесная, 15',
		'2222455179',
		7
	),
	(
		'ООО',
		'Паркет 29',
		'Петров Василий Петрович',
		'vppetrov@vl.ru',
		'987 123 56 78',
		'164500, Архангельская область, город Северодвинск, ул. Строителей, 18',
		'3333888520',
		7
	),
	(
		'ПАО',
		'Стройсервис',
		'Соловьев Андрей Николаевич',
		'ansolovev@st.ru',
		'812 223 32 00',
		'188910, Ленинградская область, город Приморск, ул. Парковая, 21',
		'4440391035',
		7
	),
	(
		'ОАО',
		'Ремонт и отделка',
		'Воробьева Екатерина Валерьевна',
		'ekaterina.vorobeva@ml.ru',
		'444 222 33 11',
		'143960, Московская область, город Реутов, ул. Свободы, 51',
		'1111520857',
		5
	),
	(
		'ЗАО',
		'МонтажПро',
		'Степанов Степан Сергеевич',
		'stepanov@stepan.ru',
		'912 888 33 33',
		'309500, Белгородская область, город Старый Оскол, ул. Рабочая, 122',
		'5552431140',
		10
	);

CREATE TABLE
	PRODUCTS (
		ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		PRODUCT_TYPE TEXT,
		NAME TEXT,
		ARTICLE CHARACTER VARYING(10),
		MIN_PRICE REAL,
		CURRENCY_TYPE TEXT
	);

INSERT INTO
	PRODUCTS (
		PRODUCT_TYPE,
		NAME,
		ARTICLE,
		MIN_PRICE,
		CURRENCY_TYPE
	)
VALUES
	(
		'Паркетная доска',
		'Паркетная доска Ясень темный однополосная 14 мм',
		'8758385',
		4456.90,
		'RUB'
	),
	(
		'Паркетная доска',
		'Инженерная доска Дуб Французская елка однополосная 12 мм',
		'8858958',
		7330.99,
		'RUB'
	),
	(
		'Ламинат',
		'Ламинат Дуб дымчато-белый 33 класс 12 мм',
		'7750282',
		1799.33,
		'RUB'
	),
	(
		'Ламинат',
		'Ламинат Дуб серый 32 класс 8 мм с фаской',
		'7028748',
		3890.41,
		'RUB'
	),
	(
		'Пробковое покрытие',
		'Пробковое напольное клеевое покрытие 32 класс 4 мм',
		'5012543',
		5450.59,
		'RUB'
	);

CREATE TABLE
	SALES (
		ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
		PRODUCT_ID INT REFERENCES PRODUCTS (ID),
		PARTNER_ID INT REFERENCES PARTNERS (ID),
		QUANTITY BIGINT,
		DATE_OF_SALE DATE
	);

SET
	DATESTYLE = "ISO, MDY";

INSERT INTO
	SALES (PRODUCT_ID, PARTNER_ID, QUANTITY, DATE_OF_SALE)
VALUES
	(1, 1, 15500, '03-23-2023'),
	(3, 1, 12350, '12-18-2023'),
	(4, 1, 37400, '06-07-2024'),
	(2, 2, 35000, '12-02-2022'),
	(5, 2, 1250, '05-17-2023'),
	(3, 2, 1000, '06-07-2024'),
	(1, 2, 7550, '07-01-2024'),
	(1, 3, 7250, '01-22-2023'),
	(2, 3, 2500, '07-05-2024'),
	(4, 4, 59050, '03-05-2023'),
	(3, 4, 37200, '03-12-2024'),
	(5, 4, 4500, '5-14-2024'),
	(3, 5, 50000, '9-19-2023'),
	(4, 5, 670000, '11-10-2023'),
	(1, 5, 35000, '4-15-2024'),
	(2, 5, 25000, '6-12-2024');