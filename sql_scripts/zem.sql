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
					sum(MNOGOLETNIE) AS "�����.��������. ",
						sum(YABLOKI) AS "������"
	FROM ZEM 	JOIN KPU_CATAL ON ZEM.ID_CATAL = KPU_CATAL.ID
				JOIN KNIGA_KATO ON KPU_CATAL.KATO_ID = KNIGA_KATO.ID
	WHERE ZEM.ID_CATAL IN (SELECT ID FROM KPU_CATAL)
	GROUP BY KNIGA_KATO.NAME, KNIGA_KATO.KATO
	ORDER BY KNIGA_KATO.KATO;
	

--========================================================================


--========================================================================

-- ��������� ���

-- ? ������ (ID) ��� � ��, ��� ������� ��������� ������ �� ������������� �������: ����� = �� + ���� + ������
SELECT ID_CATAL, VSEGO, PASHNYA, SADY, POSTROYKI, ZEM_OTHER, KPU_CATAL.ID
	FROM ZEM FULL OUTER JOIN KPU_CATAL ON KPU_CATAL.ID = ZEM.ID_CATAL
	WHERE COALESCE(VSEGO, 0) <> (COALESCE(PASHNYA, 0) + COALESCE(SADY, 0) + COALESCE(POSTROYKI, 0) + COALESCE(ZEM_OTHER, 0));


