CREATE INDEX idx_klienci_login_db ON klienci(login_db);
CREATE INDEX idx_klienci_nazwisko ON klienci(nazwisko);
CREATE INDEX idx_transakcje_zrodlo ON transakcje(id_konta_zrodlowego);
CREATE INDEX idx_transakcje_cel ON transakcje(id_konta_docelowego);
CREATE INDEX idx_transakcje_data ON transakcje(data_transakcji DESC);
CREATE INDEX idx_transakcje_tytul ON transakcje(tytul);