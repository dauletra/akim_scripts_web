SELECT count(*)
	FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT 	sum(VSEGO), sum(postroyki), sum(PASHNYA), sum(SADY), sum(POSEV),
		sum(OVOSHI), sum(LUK), sum(MNOGOLETNIE), sum(KORM_SENO), sum(SOLOMA)
	FROM zem
	WHERE ID_CATAL IN (SELECT ID FROM KPU_CATAL kc );
	

--==================================================================


-- ���. �� ������� �������� �������
SELECT KNIGA_KATO.KATO, KNIGA_KATO.NAME, count(ID_CATAL) AS "���-�� �� � �����. ����."
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				LEFT OUTER JOIN KNIGA_KATO ON KNIGA_KATO.ID = KPU_CATAL.KATO_ID
	WHERE ID_CATAL IN (SELECT ID FROM KPU_CATAL)
		AND posev > 0
	GROUP BY KNIGA_KATO.KATO, KNIGA_KATO.NAME
	ORDER BY KNIGA_KATO.KATO;

 
-- ������� ��������� ������ � �������� ��������
SELECT 	KNIGA_KATO.KATO, KNIGA_KATO.NAME AS "���������� �����", 
		count(ID_CATAL) AS "���. ��",
		sum(VSEGO) AS "����� �����",
			sum(POSTROYKI) AS "��� �����������",
			sum(COALESCE(PASHNYA, 0) + COALESCE(SADY, 0)) AS "�������������@",
			sum(ZEM_OTHER) AS "������ �����",
				sum(PASHNYA) AS "�����",
				sum(SADY)    AS "��������. ������.",
					sum(POSEV) AS "�����",
						sum(ZERNO) AS "��������",
							sum(KUKURUZA) AS "��������",
						sum(SEMENA_MASL) AS "������ ����.",
							sum(SEMENA_PODS) AS "������ ����.",
						sum(OVOSHI) AS "�����",
						sum(SOLOMA) AS "�����. ����.",
							sum(KORM_SENO) AS "����",
					sum(MNOGOLETNIE) AS "�����.��������. ",
						sum(YABLOKI) AS "������"
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE ZEM.ID_CATAL IN (SELECT ID FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME, KNIGA_KATO.KATO
	ORDER BY KNIGA_KATO.KATO;
	

--========================================================================

SELECT VSEGO AS "�����", COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) AS "�������", PASHNYA AS "�����", posev AS "�����" FROM ZEM
	WHERE ID_CATAL=37151;


-- ��������� �� ��������� ����� �����
SELECT ID_CATAL, COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) AS "�������", PASHNYA AS "�����", posev AS "�����", ZERNO AS "��������",
		SEMENA_MASL AS "�������� ����", SOLOMA AS "�������� ����", OVOSHI AS "�����", KAPUSTA, OGURCY, BAKLAZHAN, POMIDOR, TYKVA, MORKOV, LUK, SVEKLA_STOL FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	COALESCE(pashnya, 0) + COALESCE(sady, 0) < posev;

UPDATE ZEM
	SET KAPUSTA = NULL, OGURCY = NULL, BAKLAZHAN = NULL, POMIDOR = NULL, TYKVA = NULL, MORKOV = NULL, CHESNOK = NULL, LUK = NULL, SVEKLA_STOL = NULL
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
	COALESCE(pashnya, 0) + COALESCE(sady, 0) < posev; 


--========================================================================


-- ��������� ���

-- ? ������ (ID) ��� � ��, ��� ������� ��������� ������ �� ������������� �������: ����� = �� + ���� + ������
SELECT ID_CATAL, VSEGO, PASHNYA, SADY, POSTROYKI, ZEM_OTHER, KPU_CATAL.ID
	FROM ZEM FULL OUTER JOIN KPU_CATAL ON KPU_CATAL.ID = ZEM.ID_CATAL
	WHERE COALESCE(VSEGO, 0) <> (COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) + COALESCE(POSTROYKI, 0) + COALESCE(ZEM_OTHER, 0));


--========================================================================


--UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE
--UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE UPDATE


-- �������� ������� ����.��� �������
-- POSEV
UPDATE ZEM
	SET POSEV = COALESCE(ZERNO, 0) + COALESCE(SEMENA_MASL, 0) + COALESCE(SOLOMA, 0) + COALESCE(OVOSHI, 0) 
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

-- ������� ��� �������� ����
SELECT count(*)
	FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		pashnya > 0;


	
	
-- ��������
-- ZERNO
UPDATE ZEM
	SET ZERNO = COALESCE(KUKURUZA, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 200;

UPDATE ZEM
	SET KUKURUZA = COALESCE(KUKURUZA, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 200 ROWS 200;




-- �������� ���������
-- SEMENA_MASL
UPDATE ZEM
	SET SEMENA_MASL = COALESCE(SEMENA_PODS, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT count(*) FROM zem
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 300;

UPDATE ZEM
	SET SEMENA_PODS = COALESCE(SEMENA_PODS, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND pashnya > 300 ROWS 100;





-- �������� ��������
-- SOLOMA
UPDATE ZEM
	SET SOLOMA = COALESCE(KORM_SENO, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);

SELECT sum(korm_seno) FROM zem 
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) -- ���������

SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya - posev - COALESCE(korm_seno, 0)) > 320;

UPDATE ZEM
	SET KORM_SENO = COALESCE(KORM_SENO, 0) + 320
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev-COALESCE(korm_seno, 0)) > 320 ROWS 1000;


	
	
	
-- �����
-- OVOSHI
UPDATE ZEM
	SET OVOSHI = COALESCE(KAPUSTA, 0) + COALESCE(OGURCY, 0) + COALESCE(BAKLAZHAN, 0) + COALESCE(POMIDOR, 0) + COALESCE(TYKVA, 0) + COALESCE(MORKOV, 0) + 
					COALESCE(CHESNOK, 0) + COALESCE(LUK, 0) + COALESCE(SVEKLA_STOL, 0) + COALESCE(KARTOFEL, 0)
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


SELECT sum(OVOSHI) AS "ovoshi", sum(KAPUSTA) AS "kapusta", sum(OGURCY) AS "ogurcy", sum(BAKLAZHAN) AS "baklazhan", sum(POMIDOR) AS "pomidor", sum(TYKVA) AS "tykva", 
		sum(MORKOV) AS "morkov", sum(CHESNOK) AS "chesnok", sum(LUK) AS "luk", sum(SVEKLA_STOL) AS "svekla", sum(KARTOFEL) AS "kartofel" FROM zem
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL);


SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev) > 350;

UPDATE zem
	SET BAKLAZHAN = COALESCE(BAKLAZHAN, 0) + 50,
	POMIDOR = COALESCE(POMIDOR, 0) + 100,
	TYKVA = COALESCE(TYKVA, 0) + 50,
	CHESNOK = COALESCE(CHESNOK, 0) + 50,
	LUK = COALESCE(LUK, 0) + 50,
	SVEKLA_STOL = COALESCE(SVEKLA_STOL, 0) + 50
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev) > 350 ROWS 200;



SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev-ovoshi) > 400;
	
	
UPDATE zem 
	SET OGURCY = COALESCE(OGURCY, 0) + 150,
	MORKOV = COALESCE(MORKOV, 0) + 150,
	KAPUSTA = COALESCE(KAPUSTA, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev-ovoshi) > 400 ROWS 200;

	
-- ���������

SELECT count(*) FROM ZEM
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev-ovoshi-COALESCE(KARTOFEL, 0)) > 100;
	
UPDATE ZEM
	SET KARTOFEL = COALESCE(KARTOFEL, 0) + 100
	WHERE ID_CATAL IN (SELECT id FROM KPU_CATAL) AND 
		(pashnya-posev-ovoshi-COALESCE(KARTOFEL, 0)) > 100 ROWS 500;
	

	
	
	-- Update to NULL  Update to NULL  Update to NULL  Update to NULL
	-- Update to NULL  Update to NULL  Update to NULL  Update to NULL
	
	-- ���� ��������
	SELECT  sum(POSEV), sum(ZERNO), sum(kukuruza), sum(semena_masl), sum(semena_pods), 
			sum(ovoshi), sum(KAPUSTA), sum(OGURCY), sum(BAKLAZHAN), sum(POMIDOR), sum(TYKVA),
			sum(morkov), sum(chesnok), sum(LUK), sum(SVEKLA_STOL), sum(KARTOFEL), sum(SOLOMA), sum(KORM_SENO)
		FROM ZEM;
	
	UPDATE ZEM
		SET POSEV = NULL,
		ZERNO = NULL,
		KUKURUZA = NULL,
		SEMENA_MASL = NULL,
		SEMENA_PODS = NULL,
		OVOSHI = NULL,
		KAPUSTA = NULL,
		OGURCY = NULL,
		BAKLAZHAN = NULL,
		POMIDOR = NULL,
		TYKVA = NULL,
		MORKOV = NULL,
		CHESNOK = NULL,
		LUK = NULL,
		SVEKLA_STOL = NULL,
		KARTOFEL = NULL,
		SOLOMA = NULL,
		KORM_SENO = NULL;
	
	
	