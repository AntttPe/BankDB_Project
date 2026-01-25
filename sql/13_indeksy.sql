CREATE INDEX idx_klienci_pesel ON klienci(pesel);
CREATE INDEX idx_klienci_nazwisko ON klienci(nazwisko);
CREATE INDEX idx_transakcje_tytul ON transakcje(tytul);
CREATE INDEX idx_transakcje_zrodlo ON transakcje(id_konta_zrodlowego);