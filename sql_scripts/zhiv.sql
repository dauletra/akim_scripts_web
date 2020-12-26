SELECT sum(vsego) FROM zem 
	WHERE id_catal IN (SELECT id FROM KPU_CATAL);


-- Общее число дворов
SELECT count(*) FROM KPU_CATAL;


SELECT * FROM SPR_POSTR_ZHIV;
SELECT ID_CATAL, NAME_KAZ, PCOUNT AS qora_sany, CHISLO_SKM AS zhanuar_sany 
	FROM POSTR_ZHIV JOIN SPR_POSTR_ZHIV ON SPR_POSTR_ZHIV_ID=SPR_POSTR_ZHIV.ID
	WHERE PCOUNT > 0 AND CHISLO_SKM > 10;


SELECT KNIGA_KATO.NAME AS "Населенный пункт", sum(SKOT_MOL_VSEGO) AS "Скот всего", sum(KOROVY_MOL) AS "Коровы"
	FROM ZHIV JOIN KPU_CATAL ON KPU_CATAL.ID = ZHIV.ID_CATAL
			  JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE id_catal IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT 'Всего', sum(SKOT_MOL_VSEGO), sum(KOROVY_MOL)
	FROM ZHIV
	WHERE id_catal IN (SELECT id FROM KPU_CATAL);
	


-- =================================================================


-- Общее число дворов: всего
SELECT KNIGA_KATO.NAME AS "населенный пункт", count(KPU_CATAL.ID) AS "всего дворов"
	FROM KPU_CATAL JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	GROUP BY KNIGA_KATO.NAME
		UNION 
SELECT 'Всего', count(KPU_CATAL.ID)
	FROM KPU_CATAL;


-- Общее число дворов: из них имеют скот и птицу
SELECT KNIGA_KATO.NAME AS "населенный пункт", count(ID_CATAL) AS "имеют скот"
	FROM ZHIV JOIN KPU_CATAL ON ZHIV.ID_CATAL = KPU_CATAL.ID
			  JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE (coalesce(SKOT_MOL_VSEGO, 0) + coalesce(OVCY_VSEGO, 0) + coalesce(KOZY_VSEGO, 0) + coalesce(LOSHADI, 0) + coalesce(SVINJI, 0) + COALESCE(ptitsa, 0)) <> 0
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT 'Всего', count(ID_CATAL)
	FROM ZHIV
	WHERE (coalesce(SKOT_MOL_VSEGO, 0) + coalesce(OVCY_VSEGO, 0) + coalesce(KOZY_VSEGO, 0) + coalesce(LOSHADI, 0) + coalesce(SVINJI, 0) + COALESCE(ptitsa, 0)) <> 0
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL);
	
	
-- СВЕДЕНИЯ о наличии скота и птицы
SELECT 	KNIGA_KATO.NAME AS "населенный пункт",
		sum(SKOT_MOL_VSEGO) AS "скот всего", 	sum(KOROVY_MOL) AS "коровы", 	sum(BYKI_PROIZV) AS "быки",
		sum(OVCY_VSEGO) AS "овцы всего", 		sum(OVCEMATKI) AS "овцематки", 	sum(BARANY) AS "бараны",
		sum(KOZY_VSEGO) AS "козы всего", 		sum(KOZOMATKI) AS "козоматки", 	sum(KOZLY_PROIZV) AS "козлы",
	   	sum(LOSHADI) AS "лошади всего", 		sum(KOBYLY) AS "кобылы", 		sum(ZHEREBCY) AS "жеребцы", 			sum(MERINY) AS "мерины",
		sum(SVINJI) AS "свиньи", 				sum(HRYAKI) AS "хряки", 		sum(SVINOMATKI) AS "свиноматки",
		sum(PTITSA) AS "куры всего", 			sum(KURY) AS "куры", 			sum(KURY_NESUSHKI) AS "куры-несушки", 	sum(GUSI) AS "гуси", 		sum(UTKI) AS "утки"
	FROM ZHIV 	JOIN KPU_CATAL ON ZHIV.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT 	'Всего',
		sum(SKOT_MOL_VSEGO) AS "скот всего", 	sum(KOROVY_MOL) AS "коровы", 	sum(BYKI_PROIZV) AS "быки",
		sum(OVCY_VSEGO) AS "овцы всего", 		sum(OVCEMATKI) AS "овцематки", 	sum(BARANY) AS "бараны",
		sum(KOZY_VSEGO) AS "козы всего", 		sum(KOZOMATKI) AS "козоматки", 	sum(KOZLY_PROIZV) AS "козлы",
	   	sum(LOSHADI) AS "лошади всего", 		sum(KOBYLY) AS "кобылы", 		sum(ZHEREBCY) AS "жеребцы", 			sum(MERINY) AS "мерины",
		sum(SVINJI) AS "свиньи", 				sum(HRYAKI) AS "хряки", 		sum(SVINOMATKI) AS "свиноматки",
		sum(PTITSA) AS "куры всего", 			sum(KURY) AS "куры", 			sum(KURY_NESUSHKI) AS "куры-несушки", 	sum(GUSI) AS "гуси", 		sum(UTKI) AS "утки"
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- ==================================================================

-- Корасына канша мал сиятыны корсетилмеген уйлер мен ондагы жануарлар саны
SELECT 	POSTR_ZHIV.ID_CATAL, spr_postr_zhiv.id, spr_postr_zhiv.name_kaz, postr_zhiv.PCOUNT, postr_zhiv.CHISLO_SKM,
		ZHIV.SKOT_MOL_VSEGO, ZHIV.OVCY_VSEGO, ZHIV.KOZY_VSEGO, ZHIV.LOSHADI, ZHIV.PTITSA
	FROM POSTR_ZHIV JOIN SPR_POSTR_ZHIV ON postr_zhiv.spr_postr_zhiv_id = spr_postr_zhiv.id
					JOIN ZHIV ON POSTR_ZHIV.ID_CATAL = ZHIV.ID_CATAL
	WHERE postr_zhiv.pcount IS NULL or postr_zhiv.chislo_skm IS NULL;


-- Уйдеги id, жануар тури мен мал коранын тури сайкес келе бермейди, бирак оны ошибка кылып шыгармайды
SELECT z.ID_CATAL, z.PTITSA, spz.NAME_KAZ
	FROM ZHIV z JOIN POSTR_ZHIV ON z.ID_CATAL = postr_zhiv.ID_CATAL
				JOIN SPR_POSTR_ZHIV spz ON postr_zhiv.SPR_POSTR_ZHIV_ID = spz.ID
	WHERE z.ID_CATAL IN (SELECT id FROM KPU_CATAL)
		AND z.PTITSA > 0;


-- ====================================================================
-- UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
-- UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE

-- Косболтек 	KATO_ID 	255831
-- Теріс 		KATO_ID 	255827
-- Бакалы		KATO_ID		255829
-- Коктобе		KATO_ID		255830


	
-- КОРОВЫ
	
SELECT SUM(SKOT_MOL_VSEGO), SUM(KOROVY_MOL), SUM(BYKI_PROIZV)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- Увеличить быков-производителей
UPDATE ZHIV
	SET BYKI_PROIZV = COALESCE(BYKI_PROIZV, 0) + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		skot_mol_vsego > COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0) ROWS 10;

-- Увеличить коров
SELECT count(*) FROM ZHIV WHERE korovy_mol > 0 and ID_CATAL IN (SELECT id FROM KPU_CATAL);
	
UPDATE ZHIV
	SET KOROVY_MOL = COALESCE(KOROVY_MOL, 0) + 2
	WHERE KOROVY_MOL > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL)
	ROWS 1;

-- ОШИБКА скот мол. всего < коровы мол. + быки произв.
SELECT KOROVY_MOL, byki_proizv, SKOT_MOL_VSEGO
	FROM ZHIV
	WHERE skot_mol_vsego < COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0);

UPDATE ZHIV
	SET SKOT_MOL_VSEGO = COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0)
	WHERE skot_mol_vsego < COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0); -- AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- Увеличить скот всего	
SELECT count(*) FROM ZHIV WHERE SKOT_MOL_VSEGO > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET SKOT_MOL_VSEGO = SKOT_MOL_VSEGO + 3
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		skot_mol_vsego > 0 ROWS 231;

	
	
-- ОВЦЫ

SELECT SUM(OVCY_VSEGO), SUM(OVCEMATKI), SUM(BARANY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		OVCEMATKI > 2;

UPDATE ZHIV
	SET OVCEMATKI = OVCEMATKI - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		OVCEMATKI > 2 ROWS 7;

UPDATE ZHIV
	SET OVCY_VSEGO = COALESCE(OVCEMATKI, 0) + COALESCE(BARANY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);



-- КОЗЫ

SELECT SUM(KOZY_VSEGO), SUM(KOZOMATKI), SUM(KOZLY_PROIZV)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- Ошибка
SELECT KOZOMATKI, KOZLY_PROIZV
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kozy_vsego < kozomatki + kozly_proizv;

-- Изменить козлы-производители
SELECT kozly_proizv FROM ZHIV
	WHERE KOZLY_PROIZV > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZLY_PROIZV = KOZLY_PROIZV - 2
	WHERE KOZLY_PROIZV > 10 and ID_CATAL IN (SELECT id FROM KPU_CATAL) ROWS 1;

-- Изменить козоматки
SELECT kozomatki FROM ZHIV
	WHERE KOZOMATKI > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZOMATKI = KOZOMATKI - 15
	WHERE KOZOMATKI = 17 AND ID_CATAL IN (SELECT id FROM KPU_CATAL) ROWS 1;

-- Сложить козоматки и козлы-производитей
UPDATE ZHIV
	SET KOZY_VSEGO = COALESCE(kozomatki, 0) + COALESCE(kozly_proizv, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZOMATKI = KOZOMATKI - KOZLY_PROIZV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND kozy_vsego < kozomatki + kozly_proizv;


-- ЛОШАДИ
SELECT SUM(LOSHADI), SUM(KOBYLY), SUM(ZHEREBCY), SUM(MERINY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		meriny > 0;

UPDATE ZHIV
	SET meriny = meriny + 7
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		meriny > 0 ROWS 13;

UPDATE ZHIV
	SET LOSHADI = COALESCE(KOBYLY, 0) + COALESCE(ZHEREBCY, 0) + COALESCE(MERINY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- СВИНЬИ

SELECT sum(SVINJI), sum(HRYAKI), sum(SVINOMATKI)
	FROM zhiv
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET SVINJI = 0,
	hryaki = 0,
	SVINOMATKI = 0
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- Птица

SELECT SUM(PTITSA), SUM(KURY), SUM(KURY_NESUSHKI) 
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT KURY_NESUSHKI
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KURY_NESUSHKI > 20 ORDER BY kury_nesushki desc;

UPDATE ZHIV
	SET KURY_NESUSHKI = KURY_NESUSHKI - 20
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		KURY_NESUSHKI > 20 ROWS 1;

-- Куры
-- Куры несушки NULL, куры > 10 строка
SELECT KURY, KURY_NESUSHKI FROM zhiv
	WHERE KURY_NESUSHKI IS null AND ID_CATAL IN (SELECT id FROM KPU_CATAL)
	ORDER BY kury DESC;

UPDATE ZHIV
	SET KURY = KURY - 3
	WHERE KURY_NESUSHKI IS NULL AND KURY > 10 AND ID_CATAL IN (SELECT id FROM KPU_CATAL) ROWS 19;
	
UPDATE ZHIV
	SET PTITSA = KURY
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET GUSI = NULL, UTKI = NULL;

-- ====================================================================
-- Проверка ФЛК

-- Список (ID) ДХ, где Овцы живые, голов  < «овцематки + бараны-производители»:
SELECT * FROM
	ZHIV
	WHERE COALESCE(OVCY_VSEGO, 0) < (COALESCE(OVCEMATKI, 0) + COALESCE(BARANY, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- Список (ID) ДХ, где «Козы живые, голов < козоматки + козлы-производители»: 
SELECT * FROM 
	ZHIV
	WHERE COALESCE(KOZY_VSEGO, 0) < (COALESCE(KOZOMATKI, 0) + COALESCE(KOZLY_PROIZV, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- Список (ID) ДХ, где «Лошади и животные семейства лошадиных прочие, живые < кобылы +  жеребцы-производители + мерины»:
SELECT *
	FROM ZHIV
	WHERE COALESCE(LOSHADI, 0) < (COALESCE(KOBYLY, 0) + COALESCE(ZHEREBCY, 0) + COALESCE(MERINY, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- ? Список (ID) ДХ, где по постройкам для содержания скота должны быть заполнены: количество и число скотомест (помещения для нескольких видов скота и прочих видов скота проверяется только количество):
-- кез келген санды кабылдай береди, мысалы барина 1 жаза салуга болады
SELECT count(*)
	FROM POSTR_ZHIV
	WHERE PCOUNT IS NULL OR CHISLO_SKM IS NULL
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

UPDATE POSTR_ZHIV
	SET PCOUNT = 1,
		CHISLO_SKM = 1
	WHERE PCOUNT IS NULL OR CHISLO_SKM IS NULL
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL);