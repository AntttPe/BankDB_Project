-- ================================================================
-- SCENARIUSZ TESTOWY: Wpływ indeksów na wyszukiwanie transakcji
-- Cel: Wykazanie różnicy w czasie zapytania przy 100 000 rekordów
-- ================================================================

-- ----------------------------------------------------------------
-- ETAP 1: POMIAR BEZ INDEKSU (Symulacja - zapchania/ zamulenia)
-- ----------------------------------------------------------------

-- 1. upewniam sie ze indekst nie istnieje:
DROP INDEX IF EXISTS idx_transakcje_tytul;

-- 2. Wykonujemy zapytanie "kosztowne".
-- Instrukcja: Zaznacz poniższą linię i kliknij "Explain Analyze" (ikona lupy z zegarkiem w DataGrip)
EXPLAIN ANALYZE SELECT * FROM transakcje WHERE tytul = 'Transakcja nr 55555';

-- OCZEKIWANY WYNIK ETAPU 1:
-- Typ skanowania: Seq Scan (Sekwencyjny - czyta wszystko po kolei)
-- Koszt (Cost): Wysoki (np. 2000+)
-- Czas (Time): Wyższy (np. 15ms - 50ms)
-- ZADANIE: Zrób zrzut ekranu wyniku (zakładka "Explain" lub "Output").


-- ----------------------------------------------------------------
-- ETAP 2: właczenie przyspeiszenia (Indeksowanie)
-- ----------------------------------------------------------------

-- 1. Zakładamy indeks na kolumnę, po której szukamy
CREATE INDEX idx_transakcje_tytul ON transakcje(tytul);

-- 2. Ponawiamy TO SAMO zapytanie.
-- Instrukcja: Zaznacz poniższą linię i znów kliknij "Explain Analyze"
EXPLAIN ANALYZE SELECT * FROM transakcje WHERE tytul = 'Transakcja nr 55555';

-- OCZEKIWANY WYNIK ETAPU 2:
-- Typ skanowania: Index Scan (lub Bitmap Heap Scan) - skacze od razu do celu
-- Koszt (Cost): Bardzo niski (np. 8-50)
-- Czas (Time): Błyskawiczny (np. 0.05ms - 2ms)
-- ZADANIE: Zrób zrzut ekranu i porównaj z poprzednim.

-- ================================================================
-- KONIEC TESTU.
-- Wniosek do dokumentacji: Dodanie indeksu przyspieszyło wyszukiwanie X-krotnie.
-- ================================================================