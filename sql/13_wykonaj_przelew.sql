CREATE OR REPLACE PROCEDURE wykonaj_przelew(
    p_nadawca_id INT,
    p_odbiorca_id INT,
    p_kwota DECIMAL,
    p_tytul VARCHAR
)
    LANGUAGE plpgsql
    SECURITY DEFINER
AS $$
DECLARE
    v_saldo_nadawcy DECIMAL;
BEGIN
    IF p_kwota <= 0 THEN
        RAISE EXCEPTION 'Kwota przelewu musi być dodatnia';
    END IF;

    IF p_nadawca_id = p_odbiorca_id THEN
        RAISE EXCEPTION 'Nie można wykonać przelewu do swojego konta';
    END IF;

    SELECT saldo_bieżące INTO v_saldo_nadawcy
    FROM konta
    WHERE id_konta = p_nadawca_id
        FOR UPDATE;

    IF v_saldo_nadawcy < p_kwota THEN
        RAISE EXCEPTION 'Brak wystarczających środków na koncie';
    END IF;

    UPDATE konta
    SET saldo_bieżące = saldo_bieżące - p_kwota
    WHERE id_konta = p_nadawca_id;

    UPDATE konta
    SET saldo_bieżące = saldo_bieżące + p_kwota
    WHERE id_konta = p_odbiorca_id;

    INSERT INTO transakcje (
        kwota,
        tytul,
        id_konta_zrodlowego,
        id_konta_docelowego,
        typ_transakcji,
        data_transakcji
    )
    VALUES (
               p_kwota,
               p_tytul,
               p_nadawca_id,
               p_odbiorca_id,
               'PRZELEW',
               CURRENT_DATE
           );
END;
$$;