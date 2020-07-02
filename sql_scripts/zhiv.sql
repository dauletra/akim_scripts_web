SELECT sum(vsego) FROM zem 
	WHERE id_catal IN (SELECT id FROM KPU_CATAL);


-- ����� ����� ������
SELECT count(*) FROM KPU_CATAL;


SELECT * FROM SPR_POSTR_ZHIV;
SELECT ID_CATAL, NAME_KAZ, PCOUNT AS qora_sany, CHISLO_SKM AS zhanuar_sany 
	FROM POSTR_ZHIV JOIN SPR_POSTR_ZHIV ON SPR_POSTR_ZHIV_ID=SPR_POSTR_ZHIV.ID
	WHERE PCOUNT > 0 AND CHISLO_SKM > 10;


SELECT KNIGA_KATO.NAME AS "���������� �����", sum(SKOT_MOL_VSEGO) AS "���� �����", sum(KOROVY_MOL) AS "������"
	FROM ZHIV JOIN KPU_CATAL ON KPU_CATAL.ID = ZHIV.ID_CATAL
			  JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE id_catal IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT '�����', sum(SKOT_MOL_VSEGO), sum(KOROVY_MOL)
	FROM ZHIV
	WHERE id_catal IN (SELECT id FROM KPU_CATAL);
	


-- =================================================================


-- ����� ����� ������: �����
SELECT KNIGA_KATO.NAME AS "���������� �����", count(KPU_CATAL.ID) AS "����� ������"
	FROM KPU_CATAL JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	GROUP BY KNIGA_KATO.NAME
		UNION 
SELECT '�����', count(KPU_CATAL.ID)
	FROM KPU_CATAL;


-- ����� ����� ������: �� ��� ����� ���� � �����
SELECT KNIGA_KATO.NAME AS "���������� �����", count(ID_CATAL) AS "����� ����"
	FROM ZHIV JOIN KPU_CATAL ON ZHIV.ID_CATAL = KPU_CATAL.ID
			  JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE (coalesce(SKOT_MOL_VSEGO, 0) + coalesce(OVCY_VSEGO, 0) + coalesce(KOZY_VSEGO, 0) + coalesce(LOSHADI, 0) + coalesce(SVINJI, 0) + COALESCE(ptitsa, 0)) <> 0
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT '�����', count(ID_CATAL)
	FROM ZHIV
	WHERE (coalesce(SKOT_MOL_VSEGO, 0) + coalesce(OVCY_VSEGO, 0) + coalesce(KOZY_VSEGO, 0) + coalesce(LOSHADI, 0) + coalesce(SVINJI, 0) + COALESCE(ptitsa, 0)) <> 0
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL);
	
	
-- �������� � ������� ����� � �����
SELECT 	KNIGA_KATO.NAME AS "���������� �����",
		sum(SKOT_MOL_VSEGO) AS "���� �����", 	sum(KOROVY_MOL) AS "������", 	sum(BYKI_PROIZV) AS "����",
		sum(OVCY_VSEGO) AS "���� �����", 		sum(OVCEMATKI) AS "���������", 	sum(BARANY) AS "������",
		sum(KOZY_VSEGO) AS "���� �����", 		sum(KOZOMATKI) AS "���������", 	sum(KOZLY_PROIZV) AS "�����",
	   	sum(LOSHADI) AS "������ �����", 		sum(KOBYLY) AS "������", 		sum(ZHEREBCY) AS "�������", 			sum(MERINY) AS "������",
		sum(SVINJI) AS "������", 				sum(HRYAKI) AS "�����", 		sum(SVINOMATKI) AS "����������",
		sum(PTITSA) AS "���� �����", 			sum(KURY) AS "����", 			sum(KURY_NESUSHKI) AS "����-�������", 	sum(GUSI) AS "����", 		sum(UTKI) AS "����"
	FROM ZHIV 	JOIN KPU_CATAL ON ZHIV.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME
		UNION
SELECT 	'�����',
		sum(SKOT_MOL_VSEGO) AS "���� �����", 	sum(KOROVY_MOL) AS "������", 	sum(BYKI_PROIZV) AS "����",
		sum(OVCY_VSEGO) AS "���� �����", 		sum(OVCEMATKI) AS "���������", 	sum(BARANY) AS "������",
		sum(KOZY_VSEGO) AS "���� �����", 		sum(KOZOMATKI) AS "���������", 	sum(KOZLY_PROIZV) AS "�����",
	   	sum(LOSHADI) AS "������ �����", 		sum(KOBYLY) AS "������", 		sum(ZHEREBCY) AS "�������", 			sum(MERINY) AS "������",
		sum(SVINJI) AS "������", 				sum(HRYAKI) AS "�����", 		sum(SVINOMATKI) AS "����������",
		sum(PTITSA) AS "���� �����", 			sum(KURY) AS "����", 			sum(KURY_NESUSHKI) AS "����-�������", 	sum(GUSI) AS "����", 		sum(UTKI) AS "����"
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- ==================================================================

-- �������� ����� ��� ������� ������������� ����� ��� ������ ��������� ����
SELECT 	POSTR_ZHIV.ID_CATAL, spr_postr_zhiv.id, spr_postr_zhiv.name_kaz, postr_zhiv.PCOUNT, postr_zhiv.CHISLO_SKM,
		ZHIV.SKOT_MOL_VSEGO, ZHIV.OVCY_VSEGO, ZHIV.KOZY_VSEGO, ZHIV.LOSHADI, ZHIV.PTITSA
	FROM POSTR_ZHIV JOIN SPR_POSTR_ZHIV ON postr_zhiv.spr_postr_zhiv_id = spr_postr_zhiv.id
					JOIN ZHIV ON POSTR_ZHIV.ID_CATAL = ZHIV.ID_CATAL
	WHERE postr_zhiv.pcount IS NULL or postr_zhiv.chislo_skm IS NULL;


-- ������ id, ������ ���� ��� ��� ������� ���� ������ ���� ��������, ����� ��� ������ ����� ����������
SELECT z.ID_CATAL, z.PTITSA, spz.NAME_KAZ
	FROM ZHIV z JOIN POSTR_ZHIV ON z.ID_CATAL = postr_zhiv.ID_CATAL
				JOIN SPR_POSTR_ZHIV spz ON postr_zhiv.SPR_POSTR_ZHIV_ID = spz.ID
	WHERE z.ID_CATAL IN (SELECT id FROM KPU_CATAL)
		AND z.PTITSA > 0;


-- ====================================================================
-- UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE 
-- UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE

-- ��������� 	KATO_ID 	255831
-- ���� 		KATO_ID 	255827
-- ������		KATO_ID		255829
-- �������		KATO_ID		255830

SELECT SUM(SKOT_MOL_VSEGO), SUM(KOROVY_MOL), SUM(BYKI_PROIZV)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND skot_mol_vsego < COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0);

SELECT KOROVY_MOL
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KOROVY_MOL = 0;

UPDATE ZHIV
	SET SKOT_MOL_VSEGO = SKOT_MOL_VSEGO - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		skot_mol_vsego > COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0) + 1 ROWS 7;

-- ����

SELECT SUM(OVCY_VSEGO), SUM(OVCEMATKI), SUM(BARANY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		ovcy_vsego > 0;

UPDATE ZHIV
	SET OVCY_VSEGO = OVCY_VSEGO - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		ovcy_vsego > 2 ROWS 38;

UPDATE ZHIV
	SET OVCY_VSEGO = COALESCE(OVCEMATKI, 0) + COALESCE(BARANY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- ����

SELECT SUM(KOZY_VSEGO), SUM(KOZOMATKI), SUM(KOZLY_PROIZV)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT KOZOMATKI, KOZLY_PROIZV
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kozy_vsego < kozomatki + kozly_proizv;

UPDATE ZHIV
	SET KOZY_VSEGO = KOZY_VSEGO - 2
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		kozy_vsego > 2 ROWS 1;

UPDATE ZHIV
	SET KOZOMATKI = KOZOMATKI - KOZLY_PROIZV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND kozy_vsego < kozomatki + kozly_proizv;


-- ������
SELECT SUM(LOSHADI), SUM(KOBYLY), SUM(ZHEREBCY), SUM(MERINY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		LOSHADI > 0;

UPDATE ZHIV
	SET LOSHADI = LOSHADI + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		LOSHADI > 0 ROWS 48;

UPDATE ZHIV
	SET LOSHADI = COALESCE(KOBYLY, 0) + COALESCE(ZHEREBCY, 0) + COALESCE(MERINY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- �����

SELECT SUM(PTITSA), SUM(KURY), SUM(KURY_NESUSHKI) 
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KURY > 0;

UPDATE ZHIV
	SET PTITSA = PTITSA + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		PTITSA > 0 ROWS 85;

UPDATE ZHIV
	SET KURY = PTITSA
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET GUSI = NULL, UTKI = NULL;

-- ====================================================================
-- �������� ���

-- ������ (ID) ��, ��� ���� �����, �����  < ���������� + ������-�������������:
SELECT * FROM
	ZHIV
	WHERE COALESCE(OVCY_VSEGO, 0) < (COALESCE(OVCEMATKI, 0) + COALESCE(BARANY, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- ������ (ID) ��, ��� ����� �����, ����� < ��������� + �����-�������������: 
SELECT * FROM 
	ZHIV
	WHERE COALESCE(KOZY_VSEGO, 0) < (COALESCE(KOZOMATKI, 0) + COALESCE(KOZLY_PROIZV, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- ������ (ID) ��, ��� ������� � �������� ��������� ��������� ������, ����� < ������ +  �������-������������� + �������:
SELECT *
	FROM ZHIV
	WHERE COALESCE(LOSHADI, 0) < (COALESCE(KOBYLY, 0) + COALESCE(ZHEREBCY, 0) + COALESCE(MERINY, 0))
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

-- ? ������ (ID) ��, ��� �� ���������� ��� ���������� ����� ������ ���� ���������: ���������� � ����� ��������� (��������� ��� ���������� ����� ����� � ������ ����� ����� ����������� ������ ����������):
-- ��� ������ ����� �������� ������, ������ ������ 1 ���� ������ ������
SELECT count(*)
	FROM POSTR_ZHIV
	WHERE PCOUNT IS NULL OR CHISLO_SKM IS NULL
		AND ID_CATAL IN (SELECT ID FROM KPU_CATAL);

UPDATE POSTR_ZHIV
	SET PCOUNT = 1,
		CHISLO_SKM = 1
	WHERE PCOUNT IS NULL OR CHISLO_SKM IS NULL
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL);