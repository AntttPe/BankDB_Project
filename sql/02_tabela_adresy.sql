CREATE TABLE adresy(
    id_adresu SERIAL PRIMARY KEY,
    ulica varchar(100) NOT NULL,
    nr_domu int4 NOT NULL,
    kod_pocztowy varchar(6) NOT NULL,
    miasto varchar(100) NOT NULL,
    kraj varchar(100) NOT NULL,
    CHECK (kod_pocztowy ~'^[0-9]{2}\-[0-9]{3}')
);
INSERT INTO adresy(ulica, nr_domu, kod_pocztowy, miasto, kraj)
VALUES ('Mocna', 105, '10-100', 'Kraków', 'Polska')

INSERT INTO adresy(ulica, nr_domu, kod_pocztowy, miasto, kraj)
VALUES ('Silna', 15, '15-100', 'Warszawa', 'Polska')
