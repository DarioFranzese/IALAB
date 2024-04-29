%% NUOVA VERSIONE DI PROVA 
%% -- Ramiro

giornata(1..38).
squadra(napoli;roma;atalanta;lazio;juventus;torino;salernitana;bologna;cagliari;empoli;fiorentina;frosinone;genoa;hellas_verona;inter;milan;lecce;monza;sassuolo;udinese).
citta(napoli_c;roma_c;bergamo;torino_c;salerno;bologna_c;cagliari_c;empoli_c;firenze;frosinone_c;genova_c;verona;milano;lecce_c;monza_c;sassuolo_c;udine).

riferisce(napoli,napoli_c).
riferisce(roma,roma_c).
riferisce(atalanta,bergamo).
riferisce(lazio,roma_c).
riferisce(juventus,torino_c).
riferisce(torino,torino_c).
riferisce(salernitana,salerno).
riferisce(bologna,bologna_c).
riferisce(cagliari,cagliari_c).
riferisce(empoli,empoli_c).
riferisce(fiorentina,firenze).
riferisce(frosinone,frosinone_c).
riferisce(genoa,genova_c).
riferisce(hellas_verona,verona).
riferisce(inter,milano).
riferisce(milan,milano).
riferisce(lecce,lecce_c).
riferisce(monza,monza_c).
riferisce(sassuolo,sassuolo_c).
riferisce(udinese,udine).


%% Ogni squadra deve giocare due volte contro tutte le altre squadre (Andata e Ritorno - Casa e Fuori)
1 { gioca(Casa, Fuori, Citta, Giornata): citta(Citta), giornata(Giornata) } 1 :- squadra(Casa), squadra(Fuori), Casa != Fuori, riferisce(Casa, Citta).
1 { gioca(Casa, Fuori, Citta, Giornata): citta(Citta), giornata(Giornata) } 1 :- squadra(Casa), squadra(Fuori), Casa != Fuori, riferisce(Fuori, Citta).

10 { gioca(Casa, Fuori, C, G): citta(C), squadra(Casa), squadra(Fuori), Casa != Fuori } 10 :- giornata(G).

%% Squadre diverse che "riferiscono" alla stessa città non possono giocare nella stessa giornata come Casa
:- squadra(S1;S2;S3), giornata(G), riferisce(S1, C), riferisce(S2, C), S1 != S2, gioca(S1, S3, C, G), gioca(S3, S1, C, G).
:- squadra(S1;S2;S3), giornata(G), riferisce(S1, C), riferisce(S2, C), S1 != S2, gioca(S2, S3, C, G), gioca(S3, S2, C, G).

#show gioca/4.



