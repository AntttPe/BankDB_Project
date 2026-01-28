
RESET ROLE;
SET ROLE jan_klient;

BEGIN;
-- SPRAWDZ JAKIE ID MA JAN KLIENT
CALL wykonaj_przelew(101, 2, 100, 'Test izolacji');

SELECT 'JAN WIDZI:' as kto, saldo_bieżące FROM konta WHERE id_konta= 101;