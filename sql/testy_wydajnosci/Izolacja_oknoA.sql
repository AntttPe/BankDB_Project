
RESET ROLE;
SET ROLE jan_klient;

BEGIN;
-- SPRAWDZ JAKIE ID MA JAN KLIENT
CALL wykonaj_przelew(1, 3, 1500, 'Test izolacji');

SELECT 'JAN WIDZI:' as kto, saldo_bieżące FROM konta WHERE id_konta= 1;