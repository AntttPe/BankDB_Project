DROP ROLE IF EXISTS role_klient;
DROP ROLE IF EXISTS role_pracownik;
DROP ROLE IF EXISTS role_kierownik;
DROP USER IF EXISTS jan_klient;
DROP USER IF EXISTS adam_pracownik;
DROP USER IF EXISTS ewa_szefowa;

CREATE ROLE role_klient NOLOGIN;
CREATE ROLE role_pracownik NOLOGIN;
CREATE ROLE role_kierownik NOLOGIN;

GRANT CONNECT ON DATABASE "bankowosc_db" TO role_klient, role_pracownik, role_kierownik;
GRANT USAGE ON SCHEMA public TO role_klient, role_pracownik, role_kierownik;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_klient, role_pracownik, role_kierownik;

GRANT SELECT ON konta TO role_klient;
GRANT SELECT ON karty TO role_klient;
GRANT SELECT ON transakcje TO role_klient;
GRANT SELECT ON kredyty TO role_klient;
GRANT SELECT ON lokaty TO role_klient;
GRANT SELECT ON harmonogram TO role_klient;
GRANT EXECUTE ON PROCEDURE wykonaj_przelew(INT, INT, DECIMAL, VARCHAR) TO role_klient;

GRANT SELECT ON v_klienci_rodo TO role_pracownik;
GRANT SELECT, INSERT, UPDATE ON adresy TO role_pracownik;
GRANT SELECT, INSERT, UPDATE ON klienci TO role_pracownik;
GRANT SELECT, INSERT, UPDATE ON konta TO role_pracownik;
GRANT SELECT, INSERT, UPDATE ON karty TO role_pracownik;
GRANT SELECT, INSERT ON transakcje TO role_pracownik;
GRANT SELECT ON harmonogram, kredyty, lokaty TO role_pracownik;

GRANT ALL PRIVILEGES ON klienci, adresy, konta, karty, kredyty, lokaty, harmonogram, transakcje, typy_transakcji TO role_kierownik;
GRANT SELECT ON audyt_sald TO role_kierownik;
GRANT SELECT ON logi_bezpieczenstwa TO role_kierownik;

CREATE USER jan_klient WITH PASSWORD 'Kaczka123';
CREATE USER adam_pracownik WITH PASSWORD 'Kapibara123';
CREATE USER ewa_szefowa WITH PASSWORD 'Swinia123';

GRANT role_klient TO jan_klient;
GRANT role_pracownik TO adam_pracownik;
GRANT role_kierownik TO ewa_szefowa;