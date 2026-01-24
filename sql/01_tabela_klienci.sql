-- Plik: sql/01_tabela_klienci.sql
-- tabela klienci
-- SERIAL - baza bedzie nadawac sama kolejne numery (1, 2, 3...)
CREATE TABLE klienci (
    id_klienta SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel bigint UNIQUE NOT NULL, -- pesle musi mieć 11 znaków i być unikalny
    dataurodzenia DATE NOT NULL,
    email VARCHAR(100),
    telefon varchar(12) UNIQUE NOT NULL,
    id_adresu int4 NOT NULL,
    data_rejestracji DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_adresu) REFERENCES adresy(id_adresu),
    CHECK (email ~ '.*@{1}.*\.{1}.*'), -- do triggera raczej to jest, bo sie serial id psuje jak sie zrobi źle insert
    CHECK (pesel BETWEEN 10000000000 and 99999999999),
    CHECK (telefon ~'^\+[0-9]{10,12}$')
);

-- dwaj przykłądowi klięci
INSERT INTO klienci (imie, nazwisko, pesel, dataurodzenia, telefon, id_adresu, email)
VALUES ('Jan', 'Kowalski',  90010112345, '1990-01-02', '+48505505505', 1, 'jan.kowalski@email.com');

INSERT INTO klienci (imie, nazwisko, pesel, dataurodzenia, telefon, id_adresu, email)
VALUES ('Anna', 'Nowak', 95050554321, '2005-06-21', '+7505506509', 2, 'anna.nowak@email.com');

INSERT INTO klienci (imie, nazwisko, pesel, dataurodzenia, telefon,  id_adresu, email)
VALUES ('Adam', 'Małysz', 11111111111, '1978-08-30', '+7508508508', 2,  'elo@asd.pl')


