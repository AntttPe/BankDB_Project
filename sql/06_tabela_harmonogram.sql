DROP TABLE IF EXISTS harmonogram;
CREATE TABLE harmonogram(
    id_raty SERIAL PRIMARY KEY,
    id_kredytu int4 NOT NULL,
    termin_platonsci DATE,
    kwota_raty decimal(100,2) NOT NULL,
    nr_raty int4 NOT NULL,
    FOREIGN KEY (id_kredytu) REFERENCES kredyty(id_kredytu)
);
