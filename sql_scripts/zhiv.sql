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


	
-- ������
	
SELECT SUM(SKOT_MOL_VSEGO) AS "�����", SUM(KOROVY_MOL) AS "������", SUM(BYKI_PROIZV) AS "����"
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ����� � ���������� ���� �������������
SELECT BYKI_PROIZV FROM ZHIV
	WHERE BYKI_PROIZV > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ��������� �����-��������������
UPDATE ZHIV
	SET BYKI_PROIZV = BYKI_PROIZV - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		BYKI_PROIZV > 3 ROWS 1;

-- ��������� �����-��������������
UPDATE ZHIV
	SET BYKI_PROIZV = COALESCE(BYKI_PROIZV, 0) + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		skot_mol_vsego > COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0) ROWS 10;

-- ��������� ����� ------------------

SELECT count(*) FROM ZHIV 
	WHERE korovy_mol = 5 and 
		ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT sum(KOROVY_MOL) FROM ZHIV 
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		korovy_mol > 0;

UPDATE ZHIV
	SET KOROVY_MOL = KOROVY_MOL - 2
	WHERE KOROVY_MOL = 5 AND ID_CATAL IN (SELECT id FROM KPU_CATAL)
	ROWS 1;

-- ������ ���� ���. ����� < ������ ���. + ���� ������.
SELECT KOROVY_MOL, byki_proizv, SKOT_MOL_VSEGO
	FROM ZHIV
	WHERE skot_mol_vsego < COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0);

UPDATE ZHIV
	SET SKOT_MOL_VSEGO = COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0)
	WHERE skot_mol_vsego < COALESCE(korovy_mol, 0) + COALESCE(byki_proizv, 0); -- AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ��������� ���� �����	
SELECT count(*) FROM ZHIV WHERE SKOT_MOL_VSEGO > 2 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM ZHIV 
	WHERE skot_mol_vsego > COALESCE(korovy_mol, 0) + COALESCE(BYKI_PROIZV, 0) + 2 
		AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET SKOT_MOL_VSEGO = SKOT_MOL_VSEGO - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		skot_mol_vsego > COALESCE(korovy_mol, 0) + COALESCE(BYKI_PROIZV, 0) + 2 ROWS 65;

	
	
	
	
-- ����

SELECT SUM(OVCY_VSEGO), SUM(OVCEMATKI) AS "����", SUM(BARANY) AS "������"
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ���������� ����� � ������
SELECT sum(OVCEMATKI), count(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		ovcematki > 0;

UPDATE ZHIV
	SET OVCEMATKI = OVCEMATKI + 10
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		ovcematki > 0 ROWS 215;
	
UPDATE ZHIV
	SET OVCEMATKI = OVCEMATKI - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		OVCEMATKI > 2 ROWS 1;

-- ������
SELECT sum(BARANY), count(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		barany > 0;

UPDATE ZHIV
	SET BARANY = BARANY + 2
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		barany > 0 ROWS 1;
	
-- �����
UPDATE ZHIV
	SET OVCY_VSEGO = COALESCE(OVCEMATKI, 0) + COALESCE(BARANY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);






-- ����

SELECT SUM(KOZY_VSEGO), SUM(KOZOMATKI), SUM(KOZLY_PROIZV)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ������
SELECT KOZOMATKI, KOZLY_PROIZV
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kozy_vsego < kozomatki + kozly_proizv;

-- �������� �����-�������������
SELECT kozly_proizv FROM ZHIV
	WHERE KOZLY_PROIZV > 0 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZLY_PROIZV = 4
	WHERE KOZLY_PROIZV = 7 and ID_CATAL IN (SELECT id FROM KPU_CATAL) ROWS 1;

-- �������� ���������
SELECT count(kozomatki) FROM ZHIV
	WHERE KOZOMATKI = 1 AND ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZOMATKI = KOZOMATKI + 2
	WHERE KOZOMATKI = 1 AND ID_CATAL IN (SELECT id FROM KPU_CATAL) ROWS 41;

-- ������� ��������� � �����-������������
UPDATE ZHIV
	SET KOZY_VSEGO = COALESCE(kozomatki, 0) + COALESCE(kozly_proizv, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KOZOMATKI = KOZOMATKI - KOZLY_PROIZV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND kozy_vsego < kozomatki + kozly_proizv;







-- ������
SELECT SUM(LOSHADI), SUM(KOBYLY), SUM(ZHEREBCY), SUM(MERINY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ������
SELECT count(kobyly) FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kobyly > 0;

UPDATE ZHIV
	SET KOBYLY = KOBYLY + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kobyly > 0 ROWS 1;

-- �������

SELECT SUM(ZHEREBCY), COUNT(*)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		zherebcy > 0;

UPDATE ZHIV
	SET ZHEREBCY = ZHEREBCY - 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND
		ZHEREBCY > 1 ROWS 6;

-- ������

SELECT sum(MERINY), count(MERINY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		MERINY > 0;

UPDATE ZHIV
	SET MERINY = MERINY + 5
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		meriny > 0 ROWS 13;

-- �����������
UPDATE ZHIV
	SET LOSHADI = COALESCE(KOBYLY, 0) + COALESCE(ZHEREBCY, 0) + COALESCE(MERINY, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);






-- ������

SELECT sum(SVINJI), sum(HRYAKI), sum(SVINOMATKI)
	FROM zhiv
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET SVINOMATKI = 1
	WHERE ID_CATAL IN (17417, 18569, 20486, 39128);

UPDATE ZHIV
	SET SVINJI = COALESCE(hryaki, 0) + COALESCE(SVINOMATKI, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);






-- �����

SELECT SUM(PTITSA), SUM(KURY), SUM(KURY_NESUSHKI) 
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ���������: ���� ��� ���� ������� ������ ���� ����� �����
SELECT kury, kury_nesushki
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(KURY IS NULL OR kury = 0) and KURY_NESUSHKI > 0;

-- ���� �������
SELECT sum(KURY_NESUSHKI), count(KURY_NESUSHKI)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KURY_NESUSHKI > 0;

UPDATE ZHIV
	SET KURY = KURY_NESUSHKI
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

UPDATE ZHIV
	SET KURY_NESUSHKI = KURY_NESUSHKI + 1,
		KURY = KURY + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KURY_NESUSHKI > 0 AND KURY > 0 ROWS 1;

-- ����
SELECT sum(KURY), count(KURY)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		KURY > 0;
	
UPDATE ZHIV
	SET KURY = KURY + 1
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		kury > 0 ROWS 1;

-- ����� ����� ����
UPDATE ZHIV
	SET PTITSA = KURY
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


-- ����, ����

SELECT sum(INDEYKI), sum(GUSI), sum(UTKI)
	FROM ZHIV
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


UPDATE ZHIV
	SET utki = NULL, INDEYKI = NULL, GUSI = NULL
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

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