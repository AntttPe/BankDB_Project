DROP TABLE IF EXISTS karty;
CREATE TABLE karty(
    id_karty SERIAL PRIMARY KEY,
    numer_karty bigint NOT NULL UNIQUE,
    data_ważności DATE,
    cvv int4,
    czy_zablokowana BOOLEAN DEFAULT false,
    id_konta int4,
    FOREIGN KEY (id_konta) REFERENCES konta(id_konta),
    CHECK (cvv BETWEEN 100 and 999),
    CHECK(numer_karty BETWEEN 1000000000000000 and 9999999999999999)
)
-- trigger czy ważnosć > data dzisiejsza

