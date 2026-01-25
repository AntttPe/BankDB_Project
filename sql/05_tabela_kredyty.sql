DROP TABLE IF EXISTS kredyty;
CREATE TABLE kredyty(
    id_kredytu SERIAL PRIMARY KEY,
    kwota_calkowita decimal(12,2),
    do_splaty decimal(12,2) DEFAULT 0,
    oprocentowanie decimal(6,4) NOT NULL,
    data_udzielenia DATE DEFAULT CURRENT_DATE,
    id_konta int4 NOT NULL,
    FOREIGN KEY (id_konta) REFERENCES konta(id_konta)
);


