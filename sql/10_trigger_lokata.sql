CREATE OR REPLACE FUNCTION oblicz_lokate()
RETURNS TRIGGER AS $$
DECLARE
    v_ilosc_miesiecy NUMERIC;
BEGIN
    v_ilosc_miesiecy := EXTRACT(YEAR FROM AGE(NEW.data_zakonczenia, NEW.data_zalozenia)) * 12 +
                        EXTRACT(MONTH FROM AGE(NEW.data_zakonczenia, NEW.data_zalozenia));

    NEW.kwota_koncowa := NEW.kwota_poczotkowa +
                         (NEW.kwota_poczotkowa * NEW.oprocentowanie * (v_ilosc_miesiecy / 12.0));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_oblicz_lokate
BEFORE INSERT OR UPDATE ON lokaty
FOR EACH ROW
EXECUTE FUNCTION oblicz_lokate();