CREATE OR REPLACE FUNCTION sprawdz_data()
RETURNS TRIGGER AS $$
DECLARE
    nazwa_kolumny TEXT;
    data_do_sprawdzenia DATE;
BEGIN
    nazwa_kolumny := TG_ARGV[0];

    -- PostgreSQL nie pozwala napisać po prostu NEW.nazwa_kolumny.
    -- Musimy zamienić wiersz NEW na JSON i wyciągnąć pole o podanej nazwie.
    data_do_sprawdzenia := (to_jsonb(NEW)->>nazwa_kolumny)::DATE;

    -- Nadmiarowe, ale można zostawić do dalszej implementacji
    IF data_do_sprawdzenia IS NULL THEN
        RETURN NEW;
    END IF;

    IF data_do_sprawdzenia <= CURRENT_DATE THEN
        RAISE EXCEPTION 'Błąd w tabeli %: Data w kolumnie % (%) musi być późniejsza niż dzisiaj (%)',
            TG_TABLE_NAME, nazwa_kolumny, data_do_sprawdzenia, CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_karty_data
BEFORE INSERT OR UPDATE ON karty
FOR EACH ROW
EXECUTE FUNCTION sprawdz_data('data_ważności');

CREATE TRIGGER trg_check_lokaty_data
BEFORE INSERT OR UPDATE ON lokaty
FOR EACH ROW
EXECUTE FUNCTION sprawdz_data('data_zakonczenia');