CREATE TABLE lokaty (
    id_lokaty SERIAL PRIMARY KEY,
    kwota_poczotkowa DECIMAL(12,2) NOT NULL,
    oprocentowanie DECIMAL(5,4) NOT NULL,
    data_zalozenia DATE DEFAULT CURRENT_DATE,
    data_zakonczenia DATE NOT NULL,
    id_konta int4 NOT NULL,
    kwota_koncowa DECIMAL(12,2),
    FOREIGN KEY (id_konta) REFERENCES konta(id_konta)
);

INSERT INTO lokaty(kwota_poczotkowa, oprocentowanie, data_zakonczenia, id_konta)
VALUES (1000000, 0.5,'2029-01-24',4)
