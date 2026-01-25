DROP TABLE IF EXISTS transakcje;
CREATE TABLE transakcje(
    id_transakcji SERIAL PRIMARY KEY,
    kwota decimal(100,2) NOT NULL,
    data_transakcji DATE DEFAULT CURRENT_DATE,
    tytul varchar(100) NOT NULL,
    id_konta_zrodlowego int4 NOT NULL,
    id_konta_docelowego int4 NOT NULL,
    typ_transakcji varchar(30) NOT NULL,
    FOREIGN KEY (id_konta_zrodlowego) REFERENCES konta(id_konta),
    FOREIGN KEY (id_konta_docelowego) REFERENCES konta(id_konta)
);
