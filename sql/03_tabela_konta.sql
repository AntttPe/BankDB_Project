DROP TABLE IF EXISTS konta;
CREATE TABLE konta(
    id_konta SERIAL PRIMARY KEY,
    typ_konta varchar(50) DEFAULT 'Zwykłe',
    saldo_bieżące decimal(100,2) NOT NULL,
    waluta varchar(4) NOT NULL DEFAULT 'ZŁ',
    czy_aktywne BOOLEAN NOT NULL,
    id_klienta int4 NOT NULL,
    FOREIGN KEY (id_klienta) REFERENCES klienci(id_klienta)
);


--trigger czy wiek < 26; wtedy konto = młodzieżowe

CALL wykonaj_przelew(6,4,10000,'wypłata');