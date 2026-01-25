CREATE OR REPLACE FUNCTION sprawdz_wiek_i_ustaw_typ()
RETURNS TRIGGER AS $$
DECLARE
    v_data_urodzenia DATE;
    v_wiek INT;
BEGIN
    SELECT dataurodzenia INTO v_data_urodzenia
    FROM klienci
    WHERE id_klienta = NEW.id_klienta;

    v_wiek := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_data_urodzenia));

    IF v_wiek < 26 THEN
        NEW.typ_konta := 'Młodzieżowe';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ustaw_konto_mlodziezowe
BEFORE INSERT ON konta
FOR EACH ROW
EXECUTE FUNCTION sprawdz_wiek_i_ustaw_typ();