-- Plik: sql/02_tabela_klienci.sql
-- tabela klienci
-- SERIAL - baza bedzie nadawac sama kolejne numery (1, 2, 3...)
DROP TABLE IF EXISTS klienci;
CREATE TABLE klienci (
    id_klienta SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel bigint UNIQUE NOT NULL,
    dataurodzenia DATE NOT NULL,
    email VARCHAR(100),
    telefon varchar(12) UNIQUE NOT NULL,
    id_adresu int4 NOT NULL,
    data_rejestracji DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_adresu) REFERENCES adresy(id_adresu),
    CHECK (email ~ '.*@{1}.*\.{1}.*'),
    CHECK (pesel BETWEEN 10000000000 and 99999999999),
    CHECK (telefon ~'^\+[0-9]{10,12}$')
);

INSERT INTO klienci (
    imie,
    nazwisko,
    pesel,
    dataurodzenia,
    email,
    telefon,
    id_adresu
)
VALUES (
           'Jan',
           'Kowalski',
           90010112345,
           '1990-01-01',
           'jan.kowalski@email.com',
           '+48123456789',
           1
       );
