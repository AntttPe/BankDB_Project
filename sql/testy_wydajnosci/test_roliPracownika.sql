SET ROLE adam_pracownik;

SELECT 'PRACOWNIK - klienci (RODO)' AS test, *
FROM v_klienci_rodo
LIMIT 5;

SELECT 'PRACOWNIK - konta' AS test, id_konta, saldo_bieżące
FROM konta
LIMIT 5;


-- Próba usunięcia klienta
-- DELETE FROM klienci WHERE id_klienta = 1;

--Próba podejrzenia audytu finansowego
-- SELECT * FROM audyt_sald;

-- Próba podejrzenia logów bezpieczeństwa
-- SELECT * FROM logi_bezpieczenstwa;
