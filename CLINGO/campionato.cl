giornata(1..30).

squadra(napoli;roma;atalanta;lazio;torino;salernitana;bologna;cagliari;empoli;fiorentina;frosinone;genoa;hellas_verona;inter;lecce;nissa).

citta(napoli,napoli_c).
citta(roma,roma_c).
citta(atalanta,bergamo).
citta(lazio,roma_c).
citta(torino,torino_c).
citta(cagliari,cagliari_c).
citta(salernitana,napoli_c). %usato per testare 2 derby
citta(bologna,bologna_c).
citta(empoli,empoli_c).
citta(fiorentina,firenze).
citta(frosinone,frosinone_c).
citta(genoa,genova_c).
citta(hellas_verona,verona).
citta(inter,milano).
citta(lecce,lecce_c).
citta(nissa, caltanissetta).



%TUTTE LE SQUADRE GIOCANO CON TUTTE LE SQUADRE UNA E UNA SOLA VOLTA
1{partita(S1, S2, G): giornata(G)}1:- squadra(S1), squadra(S2), S1!=S2.


%OGNI SQUADRA GIOCA UNA E UNA SOLA PARTITA A SETTIMANA
:-partita(S1, S2, G), partita(S1, S3, G), S2!=S3. 
:-partita(S1, S2, G), partita(S3, S2, G), S1!=S3.
:-partita(S1, _, G), partita(_, S2, G), S1 == S2.

%NON POSSO GIOCARE DUE PARTITE NELLO STESSO STADIO
:- partita(S1, _, G), partita(S2, _, G), S1 != S2, citta(S1, C), citta(S2, C).

%DUE SQUADRE NON SI SFIDANO DUE VOLTE NELLO STESSO GIRONE
:- partita(S1, S2, G1), partita(S2, S1, G2), G1 <= 15, G2 <= 15.
:- partita(S1, S2, G1), partita(S2, S1, G2), G1 > 15, G2 > 15.

%UNA SQUADRA NON PUO' GIOCARE DUE PARTITE CONSECUTIVE IN CASA O FUORI
:- partita(S, _, G1), partita(S, _, G2), partita(S, _, G3), G3 == G2+1, G2 == G1+1.
:- partita(_, S, G1), partita(_, S, G2), partita(_, S, G3), G3 == G2+1, G2 == G1+1.

#show partita/3.



