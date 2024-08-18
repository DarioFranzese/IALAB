/**************************************************************************************************/
/**************************************************************************************************/
%NORD
%Si noti che la differenza principale con spostaAgente e' che localmente non puo' modificare i movibili 
%(es. non puo' rompere il ghiaccio o prendere il martello) quindi ha una variabile in meno da gestire.

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaOggetto(nord, pos(1, C), _, pos(1, C)).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaOggetto(nord, pos(R,C), Movibili, pos(R,C)):- NR is R-1, member(martello(pos(NR, C)), Movibili), !.
spostaOggetto(nord, pos(R,C), Movibili, pos(R,C)):- NR is R-1, member(ghiaccio(pos(NR, C)), Movibili), !.
spostaOggetto(nord, pos(R,C), Movibili, pos(R,C)):- NR is R-1, member(gemma(pos(NR, C)), Movibili), !.
spostaOggetto(nord, pos(R,C), Movibili, pos(R,C)):- NR is R-1, member(avversario(pos(NR, C)), Movibili), !.
spostaOggetto(nord, pos(R,C), _, pos(R,C)):- NR is R-1, occupata(pos(NR, C)), !.
spostaOggetto(nord, pos(R,C), _, pos(R,C)):- NR is R-1, finale(pos(NR, C)), !.


%CASO RICORSIVO STANDARD
spostaOggetto(nord, pos(R, C), Movibili,  NuovoStato):-
    NR is R-1,
    spostaOggetto(nord, pos(NR, C), Movibili,  NuovoStato).



%SUD

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaOggetto(sud, pos(R, C), _, pos(R, C)):- num_righe(R). 

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaOggetto(sud, pos(R,C), Movibili, pos(R,C)):- NR is R+1, member(martello(pos(NR, C)), Movibili), !.
spostaOggetto(sud, pos(R,C), Movibili, pos(R,C)):- NR is R+1, member(ghiaccio(pos(NR, C)), Movibili), !.
spostaOggetto(sud, pos(R,C), Movibili, pos(R,C)):- NR is R+1, member(gemma(pos(NR, C)), Movibili), !.
spostaOggetto(sud, pos(R,C), Movibili, pos(R,C)):- NR is R+1, member(avversario(pos(NR, C)), Movibili), !.
spostaOggetto(sud, pos(R,C), _, pos(R,C)):- NR is R+1, occupata(pos(NR, C)), !.
spostaOggetto(sud, pos(R,C), _, pos(R,C)):- NR is R+1, finale(pos(NR, C)), !.


%CASO RICORSIVO STANDARD
spostaOggetto(sud, pos(R, C), Movibili,  NuovoStato):-
    NR is R+1,
    spostaOggetto(sud, pos(NR, C), Movibili,  NuovoStato).


%EST

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaOggetto(est, pos(R, C), _, pos(R, C)):- num_colonne(C). 

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaOggetto(est, pos(R,C), Movibili, pos(R,C)):- NC is C+1, member(martello(pos(R, NC)), Movibili), !.
spostaOggetto(est, pos(R,C), Movibili, pos(R,C)):- NC is C+1, member(ghiaccio(pos(R, NC)), Movibili), !.
spostaOggetto(est, pos(R,C), Movibili, pos(R,C)):- NC is C+1, member(gemma(pos(R, NC)), Movibili), !.
spostaOggetto(est, pos(R,C), Movibili, pos(R,C)):- NC is C+1, member(avversario(pos(R, NC)), Movibili), !.
spostaOggetto(est, pos(R,C), _, pos(R,C)):- NC is C+1, occupata(pos(R, NC)), !.
spostaOggetto(est, pos(R,C), _, pos(R,C)):- NC is C+1, finale(pos(R, NC)), !.


%CASO RICORSIVO STANDARD
spostaOggetto(est, pos(R, C), Movibili,  NuovoStato):-
    NC is C+1,
    spostaOggetto(est, pos(R, NC), Movibili,  NuovoStato).


%OVEST

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaOggetto(ovest, pos(R, 1), _, pos(R, 1)).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaOggetto(ovest, pos(R,C), Movibili, pos(R,C)):- NC is C-1, member(martello(pos(R, NC)), Movibili), !.
spostaOggetto(ovest, pos(R,C), Movibili, pos(R,C)):- NC is C-1, member(ghiaccio(pos(R, NC)), Movibili), !.
spostaOggetto(ovest, pos(R,C), Movibili, pos(R,C)):- NC is C-1, member(gemma(pos(R, NC)), Movibili), !.
spostaOggetto(ovest, pos(R,C), Movibili, pos(R,C)):- NC is C-1, member(avversario(pos(R, NC)), Movibili), !.
spostaOggetto(ovest, pos(R,C), _, pos(R,C)):- NC is C-1, occupata(pos(R, NC)), !.
spostaOggetto(ovest, pos(R,C), _, pos(R,C)):- NC is C-1, finale(pos(R, NC)), !.


%CASO RICORSIVO STANDARD
spostaOggetto(ovest, pos(R, C), Movibili,  NuovoStato):-
    NC is C-1,
    spostaOggetto(ovest, pos(R, NC), Movibili,  NuovoStato).

/***********************************************************************************************************/
/***********************************************************************************************************/

%CASO BASE IN CUI SONO ARRIVATO AL FINALE
spostaAgente(_, pos(R, C), MovibiliPostAgente, pos(R, C), MovibiliPostAgente):- finale(pos(R,C)), !.

%NORD

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaAgente(nord, pos(1, C), MovibiliPostAgente, pos(1, C), MovibiliPostAgente).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaAgente(nord, pos(R,C), Movibili, pos(R,C), Movibili):- \+member(martello(_), Movibili), !, NR is R-1, member(ghiaccio(pos(NR, C)), Movibili), !.
spostaAgente(nord, pos(R,C), Movibili, pos(R,C), Movibili):- NR is R-1, member(gemma(pos(NR, C)), Movibili), !.
spostaAgente(nord, pos(R,C), Movibili, pos(R,C), Movibili):- NR is R-1, occupata(pos(NR, C)), !.

%SE TROVO IL MARTELLO LO PRENDO
spostaAgente(nord, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    member(martello(pos(R,C)), Movibili),
    delete(Movibili, martello(pos(R,C)), NuoviMovibili),
    NR is R-1,
    spostaAgente(nord, NuoviMovibili, pos(NR, C), NuovoStato, NuoviMovibili).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO
spostaAgente(nord, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    NR is R-1,
    member(ghiaccio(pos(NR, C)), Movibili),
    delete(Movibili, ghiaccio(pos(NR, C)), NuoviMovibili),
    spostaAgente(nord, NuoviMovibili, pos(NR, C), NuovoStato, NuoviMovibili).

%CASO RICORSIVO STANDARD
spostaAgente(nord, pos(R, C), Movibili,  NuovoStato, NuoviMovibili):-
    NR is R-1,
    spostaAgente(nord, pos(NR, C), Movibili,  NuovoStato, NuoviMovibili).



%SUD
%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaAgente(sud, pos(R, C), MovibiliPostAgente, pos(R, C), MovibiliPostAgente):-num_righe(R).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaAgente(sud, pos(R,C), Movibili, pos(R,C), Movibili):- \+member(martello(_), Movibili), !, NR is R+1, member(ghiaccio(pos(NR, C)), Movibili), !.
spostaAgente(sud, pos(R,C), Movibili, pos(R,C), Movibili):- NR is R+1, member(gemma(pos(NR, C)), Movibili), !.
spostaAgente(sud, pos(R,C), Movibili, pos(R,C), Movibili):- NR is R+1, occupata(pos(NR, C)), !.

%SE TROVO IL MARTELLO LO PRENDO
spostaAgente(sud, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    member(martello(pos(R,C)), Movibili),
    delete(Movibili, martello(pos(R,C)), NuoviMovibili),
    NR is R+1,
    spostaAgente(sud, NuoviMovibili, pos(NR, C), NuovoStato, NuoviMovibili).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO
spostaAgente(sud, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    NR is R+1,
    member(ghiaccio(pos(NR, C)), Movibili),
    delete(Movibili, ghiaccio(pos(NR, C)), NuoviMovibili),
    spostaAgente(sud, NuoviMovibili, pos(NR, C), NuovoStato, NuoviMovibili).

%CASO RICORSIVO STANDARD
spostaAgente(sud, pos(R, C), Movibili,  NuovoStato, NuoviMovibili):-
    NR is R+1,
    spostaAgente(sud, pos(NR, C), Movibili,  NuovoStato, NuoviMovibili).



%EST
%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaAgente(est, pos(R, C), MovibiliPostAgente, pos(R, C), MovibiliPostAgente):-num_colonne(C).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaAgente(est, pos(R,C), Movibili, pos(R,C), Movibili):- \+member(martello(_), Movibili), !, NC is C+1, member(ghiaccio(pos(R, NC)), Movibili), !.
spostaAgente(est, pos(R,C), Movibili, pos(R,C), Movibili):- NC is C+1, member(gemma(pos(R, NC)), Movibili), !.
spostaAgente(est, pos(R,C), Movibili, pos(R,C), Movibili):- NC is C+1, occupata(pos(R, NC)), !.

%SE TROVO IL MARTELLO LO PRENDO
spostaAgente(est, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    member(martello(pos(R,C)), Movibili),
    delete(Movibili, martello(pos(R,C)), NuoviMovibili),
    NC is C+1,
    spostaAgente(est, NuoviMovibili, pos(R, NC), NuovoStato, NuoviMovibili).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO
spostaAgente(est, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    NC is C+1,
    member(ghiaccio(pos(R, NC)), Movibili),
    delete(Movibili, ghiaccio(pos(R, NC)), NuoviMovibili),
    spostaAgente(est, NuoviMovibili, pos(R, NC), NuovoStato, NuoviMovibili).


%CASO RICORSIVO STANDARD
spostaAgente(est, pos(R, C), Movibili,  NuovoStato, NuoviMovibili):-
    NC is C+1,
    spostaAgente(est, pos(R, NC), Movibili,  NuovoStato, NuoviMovibili).




%OVEST
%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
spostaAgente(ovest, pos(R, 1), MovibiliPostAgente, pos(R, 1), MovibiliPostAgente).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
spostaAgente(ovest, pos(R,C), Movibili, pos(R,C), Movibili):- \+member(martello(_), Movibili), !, NC is C-1, member(ghiaccio(pos(R, NC)), Movibili), !.
spostaAgente(ovest, pos(R,C), Movibili, pos(R,C), Movibili):- NC is C-1, member(gemma(pos(R, NC)), Movibili), !.
spostaAgente(ovest, pos(R,C), Movibili, pos(R,C), Movibili):- NC is C-1, occupata(pos(R, NC)), !.

%SE TROVO IL MARTELLO LO PRENDO
spostaAgente(ovest, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    member(martello(pos(R,C)), Movibili),
    delete(Movibili, martello(pos(R,C)), NuoviMovibili),
    NC is C-1,
    spostaAgente(ovest, NuoviMovibili, pos(R, NC), NuovoStato, NuoviMovibili).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO
spostaAgente(ovest, pos(R,C), Movibili, NuovoStato, NuoviMovibili):-
    NC is C-1,
    member(ghiaccio(pos(R, NC)), Movibili),
    delete(Movibili, ghiaccio(pos(R, NC)), NuoviMovibili),
    spostaAgente(ovest, NuoviMovibili, pos(R, NC), NuovoStato, NuoviMovibili).


%CASO RICORSIVO STANDARD
spostaAgente(ovest, pos(R, C), Movibili,  NuovoStato, NuoviMovibili):-
    NC is C-1,
    spostaAgente(ovest, pos(R, NC), Movibili,  NuovoStato, NuoviMovibili).


