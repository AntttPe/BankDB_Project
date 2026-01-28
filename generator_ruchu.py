import psycopg2
import time
import random
from decimal import Decimal
from colorama import Fore, Style, init

# Inicjalizacja kolorów w terminalu
init(autoreset=True)

# KONFIGURACJA POŁĄCZENIA
DB_CONFIG = {
    "dbname": "bankowosc_db",
    "user": "admin",
    "password": "admin",
    "host": "localhost",
    "port": "5432"
}

TYTULY_PRZELEWOW = [
    "Opłata za czynsz", "Zwrot za pizze", "Kieszonkowe", "Faktura FV/2026/01",
    "Prezent urodzinowy", "Zakupy Biedronka", "Netflix subskrypcja",
    "Rata kredytu", "Przelew natychmiastowy", "Zrzutka na paliwo"
]

LOGI_SYTUACJE = [
    ("LOGIN_FAIL", "Nieudana próba logowania - błędne hasło"),
    ("LOGIN_FAIL", "Nieudana próba logowania - konto zablokowane"),
    ("ACCESS_DENIED", "Próba dostępu do cudzego zasobu (RLS violation)"),
    ("SQL_INJECTION", "Wykryto próbę ataku SQL Injection w formularzu"),
    ("API_ERROR", "Błąd połączenia z bramką płatności")
]


def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        return conn
    except Exception as e:
        print(f"{Fore.RED}Błąd połączenia z bazą: {e}{Style.RESET_ALL}")
        return None


def symuluj_przelew(cur):
    """Wywołuje Twoją procedurę SQL 'wykonaj_przelew'"""
    # Losujemy dwóch różnych klientów
    cur.execute("SELECT id_konta FROM konta WHERE czy_aktywne = true ORDER BY random() LIMIT 2")
    rows = cur.fetchall()

    if len(rows) < 2:
        return

    nadawca = rows[0][0]
    odbiorca = rows[1][0]
    kwota = round(random.uniform(10.0, 500.0), 2)
    tytul = random.choice(TYTULY_PRZELEWOW)

    try:
        # Wywołanie Twojej procedury PL/pgSQL
        cur.execute("CALL wykonaj_przelew(%s, %s, %s, %s)", (nadawca, odbiorca, kwota, tytul))
        print(
            f"{Fore.GREEN}[PRZELEW] {Style.RESET_ALL} Konto {nadawca} -> Konto {odbiorca}: {Fore.YELLOW}{kwota} PLN{Style.RESET_ALL} ('{tytul}')")
    except Exception as e:
        print(f"{Fore.RED}[BŁĄD PRZELEWU]{Style.RESET_ALL} {e}")


def symuluj_log_bezpieczenstwa(cur):
    """Wstawia rekord do tabeli logi_bezpieczenstwa"""
    typ, opis = random.choice(LOGI_SYTUACJE)
    user = f"user_{random.randint(1, 50)}"
    ip = f"192.168.1.{random.randint(1, 255)}"

    cur.execute("""
        INSERT INTO logi_bezpieczenstwa (uzytkownik_db, typ_zdarzenia, opis, ip_adres)
        VALUES (%s, %s, %s, %s)
    """, (user, typ, opis, ip))
    print(f"{Fore.MAGENTA}[SECURITY]{Style.RESET_ALL} Wykryto zdarzenie: {typ} ({ip})")


def symuluj_platnosc_karta(cur):
    """Zwykły UPDATE salda (płatność w sklepie)"""
    cur.execute("SELECT id_konta FROM konta ORDER BY random() LIMIT 1")
    res = cur.fetchone()
    if not res: return

    konto_id = res[0]
    kwota = round(random.uniform(5.0, 150.0), 2)

    # Aktualizacja salda (Trigger audytowy to wyłapie!)
    cur.execute("UPDATE konta SET saldo_bieżące = saldo_bieżące - %s WHERE id_konta = %s", (kwota, konto_id))
    print(f"{Fore.CYAN}[KARTA]{Style.RESET_ALL} Płatność kartą z konta {konto_id}: -{kwota} PLN")


def main():
    print(f"{Fore.BLUE}=== URUCHAMIANIE SYMULATORA RUCHU BANKOWEGO ==={Style.RESET_ALL}")
    print("Naciśnij CTRL+C, aby zakończyć.\n")

    conn = get_db_connection()
    if not conn: return

    cur = conn.cursor()

    try:
        while True:
            # Losujemy akcję (60% przelew, 20% karta, 20% security log)
            akcja = random.random()

            if akcja < 0.6:
                symuluj_przelew(cur)
            elif akcja < 0.8:
                symuluj_platnosc_karta(cur)
            else:
                symuluj_log_bezpieczenstwa(cur)

            # Losowe opóźnienie (0.5 do 2 sekund) - żeby wyglądało naturalnie
            time.sleep(random.uniform(0.5, 2.0))

    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}Zatrzymano symulację.{Style.RESET_ALL}")
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    main()