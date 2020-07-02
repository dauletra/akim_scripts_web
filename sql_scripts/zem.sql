SELECT 	sum(VSEGO), sum(postroyki), sum(PASHNYA), sum(SADY), sum(POSEV),
		sum(OVOSHI), sum(LUK), sum(MNOGOLETNIE), sum(KORM_SENO), sum(SOLOMA)
	FROM zem
	WHERE ID_CATAL IN (SELECT ID FROM KPU_CATAL kc );
	

--==================================================================


-- Кол. ДХ имеющие посевные площади
SELECT KNIGA_KATO.KATO, KNIGA_KATO.NAME, count(ID_CATAL) AS "кол-ва ДХ с посев. площ."
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				LEFT OUTER JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE ID_CATAL IN (SELECT ID FROM KPU_CATAL)
		AND posev > 0
	GROUP BY KNIGA_KATO.KATO, KNIGA_KATO.NAME
	ORDER BY KNIGA_KATO.KATO;

 
-- Наличие земельных угодий и посевных площадей
SELECT 	KNIGA_KATO.KATO, KNIGA_KATO.NAME AS "населенный пункт", 
		count(ID_CATAL) AS "кол. ДХ",
		sum(VSEGO) AS "всего земли",
			sum(POSTROYKI) AS "под постройками",
			sum(COALESCE(PASHNYA, 0) + COALESCE(SADY, 0)) AS "сельхозугодья@",
			sum(ZEM_OTHER) AS "прочие земли",
				sum(PASHNYA) AS "пашня",
				sum(SADY)    AS "многолет. насажд.",
					sum(POSEV) AS "посев",
						sum(ZERNO) AS "зерновые",
							sum(KUKURUZA) AS "кукуруза",
						sum(SEMENA_MASL) AS "семена масл.",
							sum(SEMENA_PODS) AS "семена подс.",
						sum(OVOSHI) AS "овощи",
						sum(SOLOMA) AS "культ. корм.",
							sum(KORM_SENO) AS "сено",
					sum(MNOGOLETNIE) AS "культ.многолет. ",
						sum(YABLOKI) AS "яблоки"
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE ZEM.ID_CATAL IN (SELECT ID FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME, KNIGA_KATO.KATO
	ORDER BY KNIGA_KATO.KATO;
	

--========================================================================

SELECT VSEGO AS "всего", COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) AS "сельхоз", PASHNYA AS "пашня", posev AS "посев" FROM ZEM
	WHERE ID_CATAL=37151;


-- Проверить не превышает ПОСЕВ ПАШНЮ
SELECT ID_CATAL, COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) AS "сельхоз", PASHNYA AS "пашня", posev AS "посев", ZERNO AS "зерновые",
		SEMENA_MASL AS "культуры масл", SOLOMA AS "Культуры корм", OVOSHI AS "овощи", KAPUSTA, OGURCY, BAKLAZHAN, POMIDOR, TYKVA, MORKOV, LUK, SVEKLA_STOL FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	COALESCE(pashnya, 0) + COALESCE(sady, 0) < posev;

UPDATE ZEM
	SET KAPUSTA = NULL, OGURCY = NULL, BAKLAZHAN = NULL, POMIDOR = NULL, TYKVA = NULL, MORKOV = NULL, CHESNOK = NULL, LUK = NULL, SVEKLA_STOL = NULL
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	COALESCE(pashnya, 0) + COALESCE(sady, 0) < posev; 


--========================================================================


-- Провервка ФЛК

-- ? Список (ID) КФХ и ДХ, где Наличие земельных угодий не удовлетворяет условию: Всего = СУ + ПСТР + прочие
SELECT ID_CATAL, VSEGO, PASHNYA, SADY, POSTROYKI, ZEM_OTHER, KPU_CATAL.ID
	FROM ZEM FULL OUTER JOIN KPU_CATAL ON KPU_CATAL.ID = ZEM.ID_CATAL
	WHERE COALESCE(VSEGO, 0) <> (COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) + COALESCE(POSTROYKI, 0) + COALESCE(ZEM_OTHER, 0));


--========================================================================


--UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE
--UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE


-- Посевные площади сель.хоз культур
-- POSEV
UPDATE ZEM
	SET POSEV = COALESCE(ZERNO, 0) + COALESCE(SEMENA_MASL, 0) + COALESCE(SOLOMA, 0) + COALESCE(OVOSHI, 0) 
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- Зерновые
-- ZERNO
UPDATE ZEM
	SET ZERNO = COALESCE(KUKURUZA, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 200;

UPDATE ZEM
	SET KUKURUZA = COALESCE(KUKURUZA, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 200 ROWS 200;


-- Культуры масличные
-- SEMENA_MASL
UPDATE ZEM
	SET SEMENA_MASL = COALESCE(SEMENA_PODS, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM zem
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 300;

UPDATE ZEM
	SET SEMENA_PODS = COALESCE(SEMENA_PODS, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 300 ROWS 100;


-- Культуры кормовые
-- SOLOMA
UPDATE ZEM
	SET SOLOMA = COALESCE(KORM_SENO, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT sum(korm_seno) FROM zem 
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) -- косболтек

SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	pashnya > posev + 100;

UPDATE ZEM
	SET KORM_SENO = COALESCE(KORM_SENO, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	pashnya > posev + 100 ROWS 520;


-- Овощи
-- OVOSHI
UPDATE ZEM
	SET OVOSHI = COALESCE(KAPUSTA, 0) + COALESCE(OGURCY, 0) + COALESCE(BAKLAZHAN, 0) + COALESCE(POMIDOR, 0) + COALESCE(TYKVA, 0) + COALESCE(MORKOV, 0) + 
					COALESCE(CHESNOK, 0) + COALESCE(LUK, 0) + COALESCE(SVEKLA_STOL, 0) + COALESCE(KARTOFEL, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


SELECT sum(OVOSHI) AS "ovoshi", sum(KAPUSTA) AS "kapusta", sum(OGURCY) AS "ogurcy", sum(BAKLAZHAN) AS "baklazhan", sum(POMIDOR) AS "pomidor", sum(TYKVA) AS "tykva", 
		sum(MORKOV) AS "morkov", sum(CHESNOK) AS "chesnok", sum(LUK) AS "luk", sum(SVEKLA_STOL) AS "svekla", sum(KARTOFEL) AS "kartofel" FROM zem
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > posev + 150;

UPDATE zem
	SET CHESNOK = COALESCE(CHESNOK, 0) + 50,
	LUK = COALESCE(LUK, 0) + 50,
	SVEKLA_STOL = COALESCE(SVEKLA_STOL, 0) + 50
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		pashnya > posev + 150 ROWS 11;

UPDATE zem 
	SET CHESNOK = CHESNOK - 5,
	LUK = LUK - 5,
	SVEKLA_STOL = SVEKLA_STOL - 5
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		chesnok > 10 AND luk > 10 AND svekla_stol > 10 ROWS 1;

UPDATE ZEM
	SET POMIDOR = COALESCE(POMIDOR, 0) + 10
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > posev + 10 ROWS 100;


SELECT count(*)
	FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		pashnya > posev + 1000;

UPDATE ZEM
	SET svekla_stol = COALESCE(svekla_stol, 0) + 2
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		pashnya > posev + 100 ROWS 1;
	

	