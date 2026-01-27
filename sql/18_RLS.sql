ALTER TABLE klienci ADD COLUMN IF NOT EXISTS login_db VARCHAR(50);

CREATE INDEX IF NOT EXISTS idx_klienci_login_db ON klienci(login_db);

UPDATE klienci
SET login_db = 'jan_klient'
WHERE id_klienta = (SELECT min(id_klienta) FROM klienci);

UPDATE klienci
SET login_db = 'user_' || id_klienta
WHERE login_db IS NULL;

ALTER TABLE klienci ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_siebie ON klienci
    FOR SELECT TO role_klient
    USING (login_db = current_user);

CREATE POLICY pracownik_widzi_wszystkich ON klienci
    FOR ALL TO role_pracownik, role_kierownik
    USING (true);

ALTER TABLE konta ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoje_konta ON konta
    FOR SELECT TO role_klient
    USING (
    id_klienta IN (SELECT id_klienta FROM klienci WHERE login_db = current_user)
    );

CREATE POLICY personel_widzi_konta ON konta
    FOR ALL TO role_pracownik, role_kierownik USING (true);

ALTER TABLE karty ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoje_karty ON karty
    FOR SELECT TO role_klient
    USING (
    id_konta IN (
        SELECT k.id_konta
        FROM konta k
                 JOIN klienci c ON k.id_klienta = c.id_klienta
        WHERE c.login_db = current_user
    )
    );

CREATE POLICY personel_widzi_karty ON karty
    FOR ALL TO role_pracownik, role_kierownik USING (true);

ALTER TABLE kredyty ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoje_kredyty ON kredyty
    FOR SELECT TO role_klient
    USING (
    id_konta IN (
        SELECT k.id_konta
        FROM konta k
                 JOIN klienci c ON k.id_klienta = c.id_klienta
        WHERE c.login_db = current_user
    )
    );

CREATE POLICY personel_widzi_kredyty ON kredyty
    FOR ALL TO role_pracownik, role_kierownik USING (true);

ALTER TABLE lokaty ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoje_lokaty ON lokaty
    FOR SELECT TO role_klient
    USING (
    id_konta IN (
        SELECT k.id_konta
        FROM konta k
                 JOIN klienci c ON k.id_klienta = c.id_klienta
        WHERE c.login_db = current_user
    )
    );

CREATE POLICY personel_widzi_lokaty ON lokaty
    FOR ALL TO role_pracownik, role_kierownik USING (true);

ALTER TABLE harmonogram ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoj_harmonogram ON harmonogram
    FOR SELECT TO role_klient
    USING (
    id_kredytu IN (
        SELECT kr.id_kredytu
        FROM kredyty kr
                 JOIN konta k ON kr.id_konta = k.id_konta
                 JOIN klienci c ON k.id_klienta = c.id_klienta
        WHERE c.login_db = current_user
    )
    );

CREATE POLICY personel_widzi_harmonogram ON harmonogram
    FOR ALL TO role_pracownik, role_kierownik USING (true);

ALTER TABLE transakcje ENABLE ROW LEVEL SECURITY;

CREATE POLICY klient_widzi_swoje_transakcje ON transakcje
    FOR SELECT TO role_klient
    USING (
    id_konta_zrodlowego IN (
        SELECT k.id_konta FROM konta k JOIN klienci c ON k.id_klienta = c.id_klienta WHERE c.login_db = current_user
    )
        OR
    id_konta_docelowego IN (
        SELECT k.id_konta FROM konta k JOIN klienci c ON k.id_klienta = c.id_klienta WHERE c.login_db = current_user
    )
    );

CREATE POLICY personel_widzi_transakcje ON transakcje
    FOR ALL TO role_pracownik, role_kierownik USING (true);