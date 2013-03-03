ALTER TABLE voc RENAME TO tmptable;
CREATE TABLE voc (
	en TEXT
	,ru TEXT
);
INSERT INTO voc(en, ru)
SELECT eng, ru
FROM tmptable;
DROP TABLE tmptable;