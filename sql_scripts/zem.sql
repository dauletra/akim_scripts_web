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
					sum(MNOGOLETNIE) AS "культ.многолет. ",
						sum(YABLOKI) AS "яблоки"
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE ZEM.ID_CATAL IN (SELECT ID FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME, KNIGA_KATO.KATO
	ORDER BY KNIGA_KATO.KATO;
	

--========================================================================


--========================================================================

-- Провервка ФЛК

-- ? Список (ID) КФХ и ДХ, где Наличие земельных угодий не удовлетворяет условию: Всего = СУ + ПСТР + прочие
SELECT ID_CATAL, VSEGO, PASHNYA, SADY, POSTROYKI, ZEM_OTHER, KPU_CATAL.ID
	FROM ZEM FULL OUTER JOIN KPU_CATAL ON KPU_CATAL.ID = ZEM.ID_CATAL
	WHERE COALESCE(VSEGO, 0) <> (COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) + COALESCE(POSTROYKI, 0) + COALESCE(ZEM_OTHER, 0));


