# Projekt Bazy Danych: System Bankowy

Projekt zaliczeniowy symulujący działanie bazy danych dla banku. System obsługuje klientów, konta, karty płatnicze, kredyty, lokaty oraz historię transakcji.

* Piotr Kurbiel
* Marcel Kuźma
* Antoni Pietreszewski

---

## O projekcie
Baza została oparta na silniku **PostgreSQL**. Skupiliśmy się na odwzorowaniu realnych procesów bankowych (przelewy, naliczanie odsetek, spłata rat) oraz na aspektach bezpieczeństwa danych i wydajności.

W bazie znajduje się generator danych, który automatycznie tworzy 50 klientów i 100 000 transakcji do testów.

## Zaimplementowane funkcjonalności

1.  **Struktura danych:**
    * Powyżej 10 tabel powiązanych relacjami.
    * Słowniki (np. typy transakcji, adresy).
    * Ograniczenia integralności (`CHECK`, `FOREIGN KEY`).

2.  **Logika biznesowa (PL/pgSQL):**
    * **Procedury:** `wykonaj_przelew` (transakcyjnie bezpieczne przekazywanie środków).
    * **Triggery:**
        * Automatyczne przypisywanie konta "Młodzieżowe" dla osób < 26 lat.
        * Walidacja dat ważności kart i lokat.
        * Aktualizacja salda kredytu po spłacie raty.

3.  **Bezpieczeństwo i RODO:**
    * **RLS (Row Level Security):** Zaimplementowano polityki bezpieczeństwa, dzięki którym zalogowany klient widzi *tylko* swoje dane (konta, karty, historię), a nie dane innych klientów.
    * **Maskowanie danych:** Widok `v_klienci_rodo` dla pracowników banku (ukryty PESEL).
    * **Role:** Podział na role `role_klient`, `role_pracownik`, `role_kierownik`.

4.  **Audyt i Logi:**
    * Tabela `audyt_sald` rejestruje każdą zmianę na koncie (trigger `AFTER UPDATE`), zapisując stare i nowe saldo oraz użytkownika wykonującego zmianę.
    * Tabela `logi_bezpieczenstwa` do monitorowania zdarzeń.

5.  **Wydajność i Analityka:**
    * **Indeksy:** Założone na kluczowych kolumnach (PESEL, daty, typy transakcji).
    * **Widoki Zmaterializowane:** `mv_statystyki_miesieczne` do szybkiego raportowania.
    * **Funkcje Okna:** Raporty analityczne (rankingi klientów, analiza trendów wydatków).

---

## Jak uruchomić projekt

Wymagany jest Docker oraz Docker Compose.

1.  **Postawienie bazy:**
    W terminalu w folderze projektu wpisz:
    ```bash
    docker-compose up -d
    ```

2.  **Wgranie struktury i danych:**
    Należy uruchomić skrypty z folderu `sql/` w kolejności numerycznej (od 01 do 19).
    * Skrypty 01-08: Tworzenie tabel.
    * Skrypty 09-12: Triggery.
    * Skrypt 13: Procedury.
    * Skrypt 14: **Generator danych** (tworzy klientów i 100k transakcji).
    * Skrypty 15-19: Audyt, Role, RLS, Indeksy i Raporty.

---

## Struktura plików
* `sql/` - wszystkie skrypty SQL.
* `sql/testy_wydajnosci/` - skrypty `EXPLAIN ANALYZE` dowodzące działania indeksów.
* `dokumentacja.pdf` - pełna dokumentacja techniczna projektu.
* `docker-compose.yml` - konfiguracja kontenera bazy danych.

---

## Schemat bazy danych
Diagram ERD (Entity Relationship Diagram) obrazuje on powiązania między klientami, produktami bankowymi a modułem bezpieczeństwa.

```mermaid
classDiagram
direction BT
class adresy {
   varchar(100) ulica
   integer nr_domu
   varchar(6) kod_pocztowy
   varchar(100) miasto
   varchar(100) kraj
   integer id_adresu
}
class audyt_sald {
   integer id_konta
   numeric(15,2) stare_saldo
   numeric(15,2) nowe_saldo
   numeric(15,2) kwota_zmiany
   timestamp data_zmiany
   varchar(50) uzytkownik_wykonujacy
   bigint id_audytu
}
class harmonogram {
   integer id_kredytu
   date termin_platonsci
   numeric(15,2) kwota_raty
   integer nr_raty
   boolean czy_oplacona
   integer id_raty
}
class karty {
   bigint numer_karty
   date data_ważności
   integer cvv
   boolean czy_zablokowana
   integer id_konta
   integer id_karty
}
class klienci {
   varchar(50) imie
   varchar(50) nazwisko
   bigint pesel
   date dataurodzenia
   varchar(100) email
   varchar(12) telefon
   integer id_adresu
   date data_rejestracji
   varchar(50) login_db
   integer id_klienta
}
class konta {
   varchar(50) typ_konta
   numeric(12,2) saldo_bieżące
   varchar(4) waluta
   boolean czy_aktywne
   integer id_klienta
   integer id_konta
}
class kredyty {
   numeric(15,2) kwota_calkowita
   numeric(15,2) do_splaty
   numeric(6,4) oprocentowanie
   date data_udzielenia
   integer id_konta
   integer id_kredytu
}
class logi_bezpieczenstwa {
   timestamp data_zdarzenia
   varchar(50) uzytkownik_db
   varchar(50) typ_zdarzenia
   text opis
   inet ip_adres
   integer id_logu
}
class lokaty {
   numeric(15,2) kwota_poczotkowa
   numeric(5,4) oprocentowanie
   date data_zalozenia
   date data_zakonczenia
   integer id_konta
   numeric(15,2) kwota_koncowa
   integer id_lokaty
}
class mv_statystyki_miesieczne {
   numeric rok
   numeric miesiac
   bigint liczba_transakcji
   numeric suma_obrotow
}
class transakcje {
   numeric(15,2) kwota
   date data_transakcji
   varchar(100) tytul
   integer id_konta_zrodlowego
   integer id_konta_docelowego
   varchar(30) typ_transakcji
   integer id_transakcji
}
class typy_transakcji {
   varchar(50) nazwa_pelna
   varchar(10) kod_typu
}
class v_klienci_rodo {
   integer id_klienta
   varchar(50) imie
   varchar(50) nazwisko
   text pesel_masked
   varchar(100) email
   varchar(12) telefon
}

audyt_sald  -->  konta : id_konta
harmonogram  -->  kredyty : id_kredytu
karty  -->  konta : id_konta
klienci  -->  adresy : id_adresu
konta  -->  klienci : id_klienta
kredyty  -->  konta : id_konta
lokaty  -->  konta : id_konta
transakcje  -->  konta : id_konta_zrodlowego:id_konta
transakcje  -->  konta : id_konta_docelowego:id_konta

```