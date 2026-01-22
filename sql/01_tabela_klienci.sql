-- Plik: sql/01_tabela_klienci.sql
-- tabela klienci
-- SERIAL - baza bedzie nadawac sama kolejne numery (1, 2, 3...)
CREATE TABLE klienci (
    id_klienta SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel CHAR(11) UNIQUE NOT NULL, -- pesle musi mieć 11 znaków i być unikalny
    email VARCHAR(100),
    data_rejestracji DATE DEFAULT CURRENT_DATE
);

-- dwaj przykłądowi klięci
INSERT INTO klienci (imie, nazwisko, pesel, email)
VALUES ('Jan', 'Kowalski', '90010112345', 'jan.kowalski@email.com');

INSERT INTO klienci (imie, nazwisko, pesel, email)
VALUES ('Anna', 'Nowak', '95050554321', 'anna.nowak@email.com');