--Odpal w drugim terminalu
RESET ROLE;
SET ROLE ewa_szefowa;

-- id janka to 1
SELECT 'KIEROWNIK WIDZI:' as kto, saldo_bieżące FROM konta where id_konta = 1;