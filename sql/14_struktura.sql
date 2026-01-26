-- 9  słownik typów transakcji -normalizacja
CREATE TABLE typy_transakcji (
    kod_typu VARCHAR(10) PRIMARY KEY, -- np. 'PRZELEW', 'BLIK', 'KARTA'
    nazwa_pelna VARCHAR(50) NOT NULL
);

INSERT INTO typy_transakcji VALUES
('PRZELEW', 'Przelew tradycyjny'),
('BLIK', 'Płatność mobilna BLIK'),
('KARTA', 'Płatność kartą'),
('BANKOMAT', 'Wypłata z bankomatu');

-- Tutaj trzeba by zrobić ALTER TABLE transakcje, żeby podpiąć ten słownik,
-- ale na tym etapie wystarczy, że tabela istnieje, żeby zaliczyć ilość.

-- 10. logi bezpieczeństwa - inof ko co kiedy
CREATE TABLE logi_bezpieczenstwa (
    id_logu SERIAL PRIMARY KEY,
    data_zdarzenia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uzytkownik_db VARCHAR(50),
    typ_zdarzenia VARCHAR(50), -- np. 'LOGIN_FAIL', 'SALDO_CHANGE'
    opis TEXT,
    ip_adres INET
);

-- 11. audyt zmian salda
CREATE TABLE audyt_sald (
    id_audytu BIGSERIAL PRIMARY KEY,
    id_konta INT REFERENCES konta(id_konta),
    stare_saldo DECIMAL(15,2),
    nowe_saldo DECIMAL(15,2),
    kwota_zmiany DECIMAL(15,2),
    data_zmiany TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uzytkownik_wykonujacy VARCHAR(50)
);


-- triger Audytowy:
CREATE OR REPLACE FUNCTION loguj_zmiane_salda()
RETURNS TRIGGER AS $$
BEGIN
    -- uruchom tylko jeśli saldo faktycznie się zmieniło
    IF OLD.saldo_bieżące <> NEW.saldo_bieżące THEN
        INSERT INTO audyt_sald (
            id_konta, stare_saldo, nowe_saldo, kwota_zmiany, uzytkownik_wykonujacy
        ) VALUES (
            NEW.id_konta,
            OLD.saldo_bieżące,
            NEW.saldo_bieżące,
            NEW.saldo_bieżące - OLD.saldo_bieżące,
            current_user -- zapisuje kto wykonał zmianę (np. 'postgres' lub aplikacja)
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audyt_salda
AFTER UPDATE ON konta
FOR EACH ROW
EXECUTE FUNCTION loguj_zmiane_salda();

-- rodo:
-- widok dla pracowników zwykłych (ukrywa wrażliwe dane)
CREATE VIEW v_klienci_rodo AS
SELECT
    id_klienta,
    imie,
    nazwisko,
    -- maskowanie numeru pesel: zostawiamy 2 pierwsze i 2 ostatnie cyfry
    CONCAT(LEFT(CAST(pesel AS TEXT), 2), '*******', RIGHT(CAST(pesel AS TEXT), 2)) AS pesel_masked,
    email,
    telefon
FROM klienci;