-- RAPORT 1: Ranking klientów w każdym mieście wg sumy transakcji wychodzących
-- Wykorzystuje: CTE (With) oraz Window Function (DENSE_RANK)
WITH SumyWydatkow AS (
    SELECT
        k.miasto,
        c.imie,
        c.nazwisko,
        SUM(t.kwota) as suma_wydatkow
    FROM klienci c
    JOIN adresy k ON c.id_adresu = k.id_adresu
    JOIN konta ko ON c.id_klienta = ko.id_klienta
    JOIN transakcje t ON ko.id_konta = t.id_konta_zrodlowego
    GROUP BY k.miasto, c.imie, c.nazwisko
)
SELECT * FROM (
    SELECT
        miasto,
        imie,
        nazwisko,
        suma_wydatkow,
        DENSE_RANK() OVER (PARTITION BY miasto ORDER BY suma_wydatkow DESC) as ranking_w_miescie
    FROM SumyWydatkow
) ranking
WHERE ranking_w_miescie <= 3; -- Pokazuje tylko podium w każdym mieście


-- RAPORT 2: Analiza przepływów - różnica względem poprzedniej transakcji na koncie
-- Wykorzystuje: Window Function (LAG)
SELECT
    id_konta_zrodlowego,
    data_transakcji,
    kwota,
    -- LAG sprawdza wartość z POÇZEDNIEGO wiersza w tej samej grupie
    LAG(kwota) OVER (PARTITION BY id_konta_zrodlowego ORDER BY data_transakcji) as poprzednia_kwota,
    kwota - LAG(kwota) OVER (PARTITION BY id_konta_zrodlowego ORDER BY data_transakcji) as roznica_kwot
FROM transakcje
ORDER BY id_konta_zrodlowego, data_transakcji
LIMIT 100;

-- Widok zmaterializowany: Podsumowanie miesięczne banku
-- Cel: Szybki dostęp do statystyk bez mielenia 100k rekordów za każdym razem
CREATE MATERIALIZED VIEW mv_statystyki_miesieczne AS
SELECT
    EXTRACT(YEAR FROM data_transakcji) as rok,
    EXTRACT(MONTH FROM data_transakcji) as miesiac,
    COUNT(*) as liczba_transakcji,
    SUM(kwota) as suma_obrotow
FROM transakcje
GROUP BY 1, 2
ORDER BY 1 DESC, 2 DESC;

-- Indeks na widoku (żeby jeszcze szybciej czytać raport)
CREATE INDEX idx_mv_statystyki ON mv_statystyki_miesieczne(rok, miesiac);

-- Jak odświeżyć dane po dodaniu nowych transakcji?
-- REFRESH MATERIALIZED VIEW mv_statystyki_miesieczne;