--generowanei 50 klientów
DO $$
    DECLARE
        i INT;
        v_nowe_id_adresu INT;
        v_nowe_id_klienta INT;
        v_random_pesel BIGINT;
        v_random_data DATE;
        v_miasto VARCHAR(50);
        v_imie VARCHAR(50);
        v_nazwisko VARCHAR(50);
        v_miasta TEXT[] := ARRAY['Warszawa', 'Kraków', 'Gdańsk', 'Poznań', 'Wrocław', 'Łódź', 'Katowice', 'Lublin', 'Szczecin', 'Bydgoszcz'];
        v_imiona TEXT[] := ARRAY['Jan', 'Anna', 'Piotr', 'Maria', 'Krzysztof', 'Katarzyna', 'Andrzej', 'Małgorzata', 'Tomasz', 'Agnieszka', 'Paweł', 'Barbara', 'Michał', 'Ewa', 'Marcin', 'Krystyna', 'Jakub', 'Elżbieta', 'Adam', 'Zofia'];
        v_nazwiska TEXT[] := ARRAY['Nowak', 'Kowalski', 'Wiśniewski', 'Wójcik', 'Kowalczyk', 'Kamiński', 'Lewandowski', 'Zieliński', 'Szymański', 'Woźniak', 'Dąbrowski', 'Kozłowski', 'Jankowski', 'Mazur', 'Kwiatkowski', 'Krawczyk', 'Kaczmarek', 'Grabowski', 'Zając', 'Pawłowski'];
    BEGIN
        FOR i IN 1..50 LOOP

                --wiek 18-60 i losuje randomowy dzień
                v_random_data := CURRENT_DATE - (floor(random() * (60-18+1) + 18) || ' years')::interval - (random() * 365 || ' days')::interval;
                v_random_pesel := (floor(random() * (99999999999 - 10000000000 + 1) + 10000000000))::bigint;
                v_miasto := v_miasta[floor(random() * array_length(v_miasta, 1) + 1)];
                v_imie := v_imiona[floor(random() * array_length(v_imiona, 1) + 1)];
                v_nazwisko := v_nazwiska[floor(random() * array_length(v_nazwiska, 1) + 1)];

                INSERT INTO adresy (ulica, nr_domu, kod_pocztowy, miasto, kraj)
                VALUES ('Ulica Losowa', i, '00-100', v_miasto, 'Polska')
                RETURNING id_adresu INTO v_nowe_id_adresu;

                -- Klient
                INSERT INTO klienci (imie, nazwisko, pesel, dataurodzenia, email, telefon, id_adresu)
                VALUES (
                           v_imie,
                           v_nazwisko,
                           v_random_pesel,
                           v_random_data,
                           lower(v_imie) || '.' || lower(v_nazwisko) || v_random_pesel || '@bank.pl',
                           '+48' || (floor(random() * (899999999 - 500000000 + 1) + 500000000))::text,
                           v_nowe_id_adresu
                       )
                RETURNING id_klienta INTO v_nowe_id_klienta;

                IF v_nowe_id_klienta IS NOT NULL THEN
                    INSERT INTO konta (typ_konta, saldo_bieżące, waluta, czy_aktywne, id_klienta)
                    VALUES ('Zwykłe', (random()*50000)::decimal(10,2), 'ZŁ', true, v_nowe_id_klienta);
                END IF;

            END LOOP;
    END $$;

-- 100 transakcji
DO $$
    DECLARE
        i INT;
        v_min_konto INT;
        v_max_konto INT;
    BEGIN
        SELECT min(id_konta), max(id_konta) INTO v_min_konto, v_max_konto FROM konta;

        IF v_min_konto IS NOT NULL AND v_max_konto IS NOT NULL THEN
            FOR i IN 1..100000 LOOP
                    INSERT INTO transakcje (
                        kwota,
                        tytul,
                        id_konta_zrodlowego,
                        id_konta_docelowego,
                        typ_transakcji,
                        data_transakcji
                    )
                    VALUES (
                               (random() * 1000)::decimal(10,2),
                               'Transakcja nr ' || i, -- Przewidywalny tytuł (dla indeksów)
                               floor(random() * (v_max_konto - v_min_konto + 1) + v_min_konto)::int,
                               floor(random() * (v_max_konto - v_min_konto + 1) + v_min_konto)::int,
                               'PRZELEW',
                               CURRENT_DATE - (random() * 365)::int
                           );
                END LOOP;
        END IF;
    END $$;


--Karty, Lokaty, Kredyty

DO $$
    DECLARE
        r RECORD;
        v_kredyt_id INT;
        v_raty_ilosc INT := 12;
        j INT;
        v_termin DATE;
        v_czy_oplacona BOOLEAN;
    BEGIN
        FOR r IN SELECT id_konta FROM konta LOOP

                -- 70% szans
                IF (random() < 0.7) THEN
                    INSERT INTO karty (numer_karty, data_ważności, cvv, czy_zablokowana, id_konta)
                    VALUES (
                               (1000000000000000 + (r.id_konta * 100000) + floor(random() * 90000))::bigint,
                               CURRENT_DATE + (floor(random() * 1000 + 365) || ' days')::interval,
                               floor(random() * (999 - 100 + 1) + 100)::int,
                               (random() < 0.05),
                               r.id_konta
                           ) ON CONFLICT DO NOTHING;
                END IF;

                -- 2. LOKATY (30% szans)
                IF (random() < 0.3) THEN
                    INSERT INTO lokaty (kwota_poczotkowa, oprocentowanie, data_zalozenia, data_zakonczenia, id_konta)
                    VALUES (
                               (random() * 10000 + 1000)::decimal(12,2),
                               (random() * 0.05 + 0.01)::decimal(5,4),
                               CURRENT_DATE - (floor(random() * 300) || ' days')::interval,
                               CURRENT_DATE + (floor(random() * 300) || ' days')::interval,
                               r.id_konta
                           );
                END IF;

                -- 3. KREDYTY (20% szans)
                IF (random() < 0.2) THEN
                -- A) Wstawiamy kredyt
                INSERT INTO kredyty (kwota_calkowita, oprocentowanie, data_udzielenia, id_konta)
                VALUES (
                           (random() * 200000 + 2000)::decimal(12,2),
                           0.08,
                           CURRENT_DATE - INTERVAL '1 year',
                           r.id_konta
                       )
                RETURNING id_kredytu INTO v_kredyt_id;

                -- B) Generujemy harmonogram
                FOR j IN 1..v_raty_ilosc LOOP
                        -- Wyliczamy datę raty
                        v_termin := (CURRENT_DATE - INTERVAL '1 year' + (j || ' months')::interval)::DATE;

                        --  jeśli termin był wczoraj lub dawniej, to uznajemy za spłaconą
                        IF v_termin < CURRENT_DATE THEN
                            v_czy_oplacona := TRUE;
                        ELSE
                            v_czy_oplacona := FALSE;
                        END IF;

                        INSERT INTO harmonogram (id_kredytu, termin_platonsci, kwota_raty, nr_raty, czy_oplacona)
                        VALUES (
                                   v_kredyt_id,
                                   v_termin,
                                   -- dzielenie może powodować błędy groszowe (np. 100/3 = 33.33),
                                   -- co sprawi, że suma rat nie da idealnie kwoty całkowitej.
                                   -- Na potrzeby testów jest OK, w produkcji ostatnia rata wyrównuje różnicę.
                                   (SELECT round(kwota_calkowita / v_raty_ilosc, 2) FROM kredyty WHERE id_kredytu = v_kredyt_id),
                                   j,
                                   v_czy_oplacona
                               );
                    END LOOP;
            END IF;

        END LOOP;
    END $$;