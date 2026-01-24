
CREATE TABLE harmonogram(
    id_raty SERIAL PRIMARY KEY,
    id_kredytu int4 NOT NULL,
    termin_platonsci DATE,
    kwota_raty decimal(100,2) NOT NULL,
    nr_raty int4 NOT NULL,
    FOREIGN KEY (id_kredytu) REFERENCES kredyty(id_kredytu)
);

INSERT into harmonogram(id_kredytu, termin_platonsci, kwota_raty, nr_raty)
VALUES(1, '2026-02-24', 1000.00, 1);

INSERT into harmonogram(id_kredytu, termin_platonsci, kwota_raty, nr_raty)
VALUES(1, '2026-02-24', 5000.00, 1);