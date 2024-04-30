giornata(1..38).

squadra(napoli;roma;atalanta;lazio;juventus;torino;salernitana;bologna;cagliari;empoli;fiorentina;frosinone;genoa;hellas_verona;inter;milan;lecce;monza;sassuolo;udinese).

citta(napoli,napoli_c).
citta(roma,roma_c).
citta(atalanta,bergamo).
citta(lazio,roma_c).
citta(juventus,torino_c).
citta(torino,torino_c).
citta(salernitana,salerno).
citta(bologna,bologna_c).
citta(cagliari,cagliari_c).
citta(empoli,empoli_c).
citta(fiorentina,firenze).
citta(frosinone,frosinone_c).
citta(genoa,genova_c).
citta(hellas_verona,verona).
citta(inter,milano).
citta(milan,milano).
citta(lecce,lecce_c).
citta(monza,monza_c).
citta(sassuolo,sassuolo_c).
citta(udinese,udine).

%TUTTE LE SQUADRE GIOCANO CON TUTTE LE SQUADRE UNA E UNA SOLA VOLTA
1{partita(S1, S2, G): giornata(G)}1:- squadra(S1), squadra(S2), S1!=S2.

%OGNI GIORNATA VENGONO GIOCATE 10 PARTITE
%10{partita(S1, S2, G): squadra(S1), squadra(S2)}10:- giornata(G).


%OGNI SQUADRA GIOCA UNA E UNA SOLA PARTITA A SETTIMANA
:-partita(S1, S2, G), partita(S1, S3, G), S2!=S3. 
:-partita(S1, S2, G), partita(S3, S2, G), S1!=S3.
:-partita(S1, _, G), partita(_, S2, G), S1 == S2.

%NON POSSO GIOCARE DUE PARTITE NELLO STESSO STADIO
:- partita(S1, _, G), partita(S2, _, G), S1 != S2, citta(S1, C), citta(S2, C).



#show partita/3.



