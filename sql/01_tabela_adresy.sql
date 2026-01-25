DROP TABLE IF EXISTS adresy;
CREATE TABLE adresy(
    id_adresu SERIAL PRIMARY KEY,
    ulica varchar(100) NOT NULL,
    nr_domu int4 NOT NULL,
    kod_pocztowy varchar(6) NOT NULL,
    miasto varchar(100) NOT NULL,
    kraj varchar(100) NOT NULL,
    CHECK (kod_pocztowy ~'^[0-9]{2}\-[0-9]{3}')
);

INSERT INTO adresy (
    ulica,
    nr_domu,
    kod_pocztowy,
    miasto,
    kraj
)
VALUES (
           'Kwiatowa',
           12,
           '00-123',
           'Warszawa',
           'Polska'
       );

