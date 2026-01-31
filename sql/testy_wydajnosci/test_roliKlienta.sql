SET ROLE jan_klient;

SELECT 'KLIENT - moje konta' AS test, id_konta, saldo_bieżące
FROM konta;

SELECT 'KLIENT - moje transakcje' AS test, id_transakcji, kwota, tytul
FROM transakcje
ORDER BY data_transakcji DESC
LIMIT 3;


-- TRZEBA PRZED TESTEM ZOBACZYC ID JANA
CALL wykonaj_przelew( 1,10, 50,'Test przelewu klient');

--Próba zmiany salda
 --SET ROLE jan_klient;
--UPDATE konta SET saldo_bieżące = 1000000;

--  Próba usunięcia  transakcji z historii, by skarbówka nie miała problem
--DELETE FROM transakcje WHERE kwota > 0;