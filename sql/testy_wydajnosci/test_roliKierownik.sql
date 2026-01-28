RESET ROLE;
SET ROLE ewa_szefowa;

SELECT 'KIEROWNIK - audyt' AS test, uzytkownik_wykonujacy, kwota_zmiany, data_zmiany
FROM audyt_sald
ORDER BY data_zmiany DESC
LIMIT 5;


SELECT 'KIEROWNIK - raport finansowy' AS test,
       COUNT(*) as liczba_kont,
       SUM(saldo_bieżące) as suma_srodkow_w_banku
FROM konta;

--  dopisanie wpisu do audytu
--INSERT INTO audyt_sald (id_konta, stare_saldo, nowe_saldo, kwota_zmiany, uzytkownik_wykonujacy) VALUES (1, 0, 1000000, 1000000, 'ewa_szefowa');

--  całej historii audytu
--DELETE FROM audyt_sald;

RESET ROLE;