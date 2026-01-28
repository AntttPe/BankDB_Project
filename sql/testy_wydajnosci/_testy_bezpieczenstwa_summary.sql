-- ================================================================
-- SCENARIUSZE TESTOWE BEZPIECZEŃSTWA (Security Acceptance Tests)
-- Cel: Udowodnienie, że Role i RLS działają poprawnie.
-- ================================================================

-- ----------------------------------------------------------------
-- SCENARIUSZ 1: KLIENT (JAN) - Próba dostępu do danych
-- ----------------------------------------------------------------
RESET ROLE;
SET ROLE jan_klient; -- Logujemy się jako Jan

-- A) Czy widzę swoje konta? (POWINNO DZIAŁAĆ)
SELECT 'JAN WIDZI:' as kto, id_konta, saldo_bieżące
FROM konta;
-- Wynik: Zwróci tylko konta Jana, Nie widzi konta nr 2, 3...

-- B) Czy widzę historię transakcji? (POWINNO DZIAŁAĆ)
SELECT 'JAN - transakcje' AS test, id_transakcji, kwota, tytul
FROM transakcje
ORDER BY data_transakcji DESC
LIMIT 3;

-- C) PRÓBA ATAKU: Czy mogę zmienić sobie saldo? (POWINNO SIĘ NIE UDAĆ)
-- Próba ustawienia miliona złotych na koncie nr 1
UPDATE konta SET saldo_bieżące = 1000000 WHERE id_konta = 1;
-- Oczekiwany wynik: ERROR: permission denied for table konta
-- (lub 0 rows updated jeśli RLS ukryje wiersz do edycji)

-- D) PRÓBA ATAKU: Czy mogę usunąć historię, żeby ukryć wydatki? (POWINNO SIĘ NIE UDAĆ)
DELETE FROM transakcje WHERE kwota > 0;
-- Oczekiwany wynik: ERROR: permission denied for table transakcje


-- ----------------------------------------------------------------
-- SCENARIUSZ 2: PRACOWNIK (ADAM) - RODO i Obsługa
-- ----------------------------------------------------------------
RESET ROLE;
SET ROLE adam_pracownik;

-- A) Czy widzę klientów? (POWINNO DZIAŁAĆ, ALE Z MASKĄ)
SELECT 'PRACOWNIK - klienci (RODO)' AS test, id_klienta, nazwisko, pesel_masked
FROM v_klienci_rodo
LIMIT 5;
-- Oczekiwany wynik: PESEL widoczny jako "90*******12"

-- B) Czy widzę salda klientów? (POWINNO DZIAŁAĆ - obsługa w okienku)
SELECT 'PRACOWNIK - konta' AS test, id_konta, saldo_bieżące
FROM konta
WHERE id_konta = 1;

-- C) PRÓBA NADUŻYCIA: Czy mogę usunąć niewygodnego klienta? (POWINNO SIĘ NIE UDAĆ)
DELETE FROM klienci WHERE id_klienta = 1;
-- Oczekiwany wynik: ERROR: permission denied for table klienci

-- D) Czy mogę podglądać logi bezpieczeństwa? (POWINNO SIĘ NIE UDAĆ)
SELECT * FROM audyt_sald;
-- Oczekiwany wynik: ERROR: permission denied for table audyt_sald


-- ----------------------------------------------------------------
-- SCENARIUSZ 3: KIEROWNIK (EWA) - Pełna kontrola i Audyt
-- ----------------------------------------------------------------
RESET ROLE;
SET ROLE ewa_szefowa;

-- A) Czy widzę wszystko? (POWINNO DZIAŁAĆ)
SELECT 'KIEROWNIK WIDZI:' as kto, saldo_bieżące FROM konta where id_konta = 1;

-- B) Sprawdzenie Audytu (Kto zmieniał salda?)
SELECT 'KIEROWNIK - audyt' AS test, uzytkownik_wykonujacy, kwota_zmiany, data_zmiany
FROM audyt_sald
ORDER BY data_zmiany DESC
LIMIT 5;

-- C) Raport finansowy (Widok zmaterializowany)
SELECT * FROM mv_statystyki_miesieczne LIMIT 5;

-- D) PRÓBA FAŁSZERSTWA: Czy kierownik może sfałszować audyt? (POWINNO SIĘ NIE UDAĆ)
-- Próba ręcznego dopisania rekordu do audytu
INSERT INTO audyt_sald (id_konta, stare_saldo, nowe_saldo, kwota_zmiany, uzytkownik_wykonujacy)
VALUES (1, 0, 1000000, 1000000, 'haker');
-- Oczekiwany wynik: ERROR: permission denied (lub trigger zablokuje, zależnie od konfiguracji)

-- E) Próba wyczyszczenia śladów (DELETE audyt)
DELETE FROM audyt_sald;
-- Oczekiwany wynik: ERROR: permission denied (nawet szef nie powinien usuwać audytu!)