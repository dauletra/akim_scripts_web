SELECT DATE_ENTER FROM KPU_RZHF WHERE DATE_ENTER IS NOT NULL;


UPDATE KPU_RZHF
	SET date_enter = round(rand() * 25+1) || '.' || round(rand() * 10 + 1) || '.' || round(2014 - rand()*24)
	WHERE DATE_ENTER IS NULL;


SELECT 'daulet';