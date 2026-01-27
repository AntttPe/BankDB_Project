CREATE OR REPLACE FUNCTION przelicz_saldo_kredytu()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE kredyty
    SET do_splaty = kwota_calkowita - (
        SELECT COALESCE(SUM(kwota_raty), 0)
        FROM harmonogram
        WHERE id_kredytu = kredyty.id_kredytu
             AND czy_oplacona = TRUE
    )
    WHERE id_kredytu = NEW.id_kredytu OR id_kredytu = OLD.id_kredytu;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_aktualizacja_salda
AFTER INSERT OR UPDATE OR DELETE ON harmonogram
FOR EACH ROW
EXECUTE FUNCTION przelicz_saldo_kredytu();
