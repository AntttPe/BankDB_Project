
CREATE TABLE konta(
    id_konta SERIAL PRIMARY KEY,
    typ_konta varchar(50) DEFAULT 'Zwykłe',
    saldo_bieżące decimal(100,2) NOT NULL,
    waluta varchar(4) NOT NULL DEFAULT 'ZŁ',
    czy_aktywne BOOLEAN NOT NULL,
    id_klienta int4 NOT NULL,
    FOREIGN KEY (id_klienta) REFERENCES klienci(id_klienta)
);

INSERT INTO konta(typ_konta, saldo_bieżące,  waluta, czy_aktywne, id_klienta)
VALUES('Oszczędnościowe', 100, 'ZŁ', true, 3);

INSERT INTO konta(saldo_bieżące, czy_aktywne, id_klienta)
VALUES(0,true,4);

--trigger czy wiek < 26; wtedy konto = młodzieżowe