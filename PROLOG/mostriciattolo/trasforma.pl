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
    
/*
%SUD
spostaAgente(sud, pos(R, C), pos(R, C), _):- num_righe(R).

spostaAgente(sud, pos(R,C), pos(R,C), 0):- NR is R+1, my_ghiaccio(pos(NR, C)).
spostaAgente(sud, pos(R,C), pos(R,C), _):- NR is R+1, my_gemma(pos(NR, C)).
spostaAgente(sud, pos(R,C), pos(R,C), _):- NR is R+1, occupata(pos(NR, C)).

spostaAgente(sud, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NR is R+1,
    spostaAgente(sud, pos(NR, C), pos(RNuovo, CNuovo), 1).

spostaAgente(sud, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NR is R+1,
    my_ghiaccio(pos(NR, C)),
    retract(my_ghiaccio(pos(NR, C))), %DA CONTROLLARE QUESTA SINTASSI
    spostaAgente(sud, pos(NR, C), pos(RNuovo, CNuovo), 1).

spostaAgente(sud, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    NR is R+1,
    spostaAgente(sud, pos(NR, C), pos(RNuovo, CNuovo), Martello).

%EST
spostaAgente(est, pos(R, C), pos(R, C), _):- num_colonne(C).

spostaAgente(est, pos(R,C), pos(R,C), 0):- NC is C+1, my_ghiaccio(pos(R, NC)).
spostaAgente(est, pos(R,C), pos(R,C), _):- NC is C+1, my_gemma(pos(R, NC)).
spostaAgente(est, pos(R,C), pos(R,C), _):- NC is C+1, occupata(pos(R, NC)).

spostaAgente(est, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NC is C+1,
    spostaAgente(est, pos(R, NC), pos(RNuovo, CNuovo), 1).

spostaAgente(est, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NC is C+1,
    my_ghiaccio(pos(R, NC)),
    retract(my_ghiaccio(pos(R, NC))), %DA CONTROLLARE QUESTA SINTASSI
    spostaAgente(est, pos(R, NC), pos(RNuovo, CNuovo), 1).

spostaAgente(est, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    NC is C+1,
    spostaAgente(est, pos(R, NC), pos(RNuovo, CNuovo), Martello).


%OVEST
spostaAgente(ovest, pos(R, 1), pos(R, 1), _).

spostaAgente(ovest, pos(R,C), pos(R,C), 0):- NC is C-1, my_ghiaccio(pos(R, NC)).
spostaAgente(ovest, pos(R,C), pos(R,C), _):- NC is C-1, my_gemma(pos(R, NC)).
spostaAgente(ovest, pos(R,C), pos(R,C), _):- NC is C-1, occupata(pos(R, NC)).

spostaAgente(ovest, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NC is C-1,
    spostaAgente(ovest, pos(R, NC), pos(RNuovo, CNuovo), 1).

spostaAgente(ovest, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NC is C-1,
    my_ghiaccio(pos(R, NC)),
    retract(my_ghiaccio(pos(R, NC))), %DA CONTROLLARE QUESTA SINTASSI
    spostaAgente(ovest, pos(R, NC), pos(RNuovo, CNuovo), 1).

spostaAgente(ovest, pos(R, C), pos(RNuovo, CNuovo), Movibili):-
    NC is C-1,
    spostaAgente(ovest, pos(R, NC), pos(RNuovo, CNuovo), Movibili).


*/
/*QUESTI SERVONO SOLO PER TESTARE GLI ALTRI PREDICATI */
%spostaAgente(_, _, [_ | CodaMovibili], pos(1,1), CodaMovibili).
spostaOggetto(_, _, _, pos(1,1)).
/********************************************************************/

%al posto del secondo movibili ordinati si puo' passare la lista vuota e si costruisce via via ad ogni iterazione, evitando di fare una delete
%e un reinserimento (molto piu' intelligente). Prima di cambiare cio' mi voglio accertare che funzioni tutto
trasforma(Azione, Corrente, Movibili, NuovoStato, NuoviMovibili):- %NuoviMovibili dovrebbe avere sempre il martello in testa (se non e' stato preso)
    ordina(Azione, [corrente(Corrente) | Movibili], MovibiliOrdinati), %il predicato corrente verra' usato per identificare l' agente
    sposta(Azione, MovibiliOrdinati, MovibiliOrdinati, _, NuovoStato, NuoviMovibili), !. %questo wrapper prendera' un movibile alla volta e lo spostera', restituendo poi i NuoviMovibili (potenzialmente prendiamo il martello
                                                                                        %oppure rompiamo il ghiaccio) e il nuovo stato dell' agente.
                                                                                        %Questo potra' chiamare spostaAgente o spostaOggetto a seconda se l' elemento corrente della lista sia uno o l' altro
                                                                                        %Questo e' necessario per il modo in cui affrontano gli ostacoli i due tipi di movibili
                                                                        

%CASO BASE
%credo vada aggiunto qualche cut
%abbiamo spostato tutti i movibili (Movibili=[]) e quindi rimuoviamo il corrente dai nuovi movibili e mettiamo il martello in testa (cosa che trasforma deve garantire)
%TESTATO FUNZIONA
sposta(_, [], NuoviMovibili, NuovoStato, NuovoStato, [martello(X) | NuoviMovibiliFinali]):-
    delete(NuoviMovibili, corrente(_), NM),
    getPosizioneMartello(NM, X),
    delete(NM, martello(_), NuoviMovibiliFinali), !. %rimuovilo dalla lista per essere sicuro stia solo in testa                                                             


%TESTATO CON spostaAgente fake E FUNZIONA
sposta(Azione, [ corrente(X) | CodaMovibili], TempMov, _, NuovoStato, NuoviMovibili):-
    spostaAgente(Azione, X, TempMov, NuovoStatoAgente, MovibiliPostAgente), %questo e' l'unico predicato che dovra' modificare NuovoStato
    delete(MovibiliPostAgente, corrente(X), NuovaCodaMovibili), %Movibili post agente sara' l' elenco dei movibili potenzialmente primo di ghiaccio e martello, tuttavia contiene ancora la posizione
                                                                       %del corrente, che va quindi tolta per poi aggiungerci il nuovo corrente
    sposta(Azione, CodaMovibili, [corrente(NuovoStato) | NuovaCodaMovibili], NuovoStatoAgente, NuovoStato, NuoviMovibili). %metto il corrente in testa tanto e' indifferente
                                                                                                         %Occhio All' utilizzo di NuovoStato non mi convince

%TESTATO CON spostaOggetto fake E FUNZIONA
%METTENDO DEI DONT CARE AL POSTO DELLE ULTIME DUE VARIABILI (ANCHE SE QUI NON VENGONO MAI ISTANZIATE) NON FUNZIONA PIU', BISOGNEREBBE
%FARE UN' ANALISI PIU' ATTENTA COL TRACE (C' E' QUALCOSA DI TEORIA CHE MI STA SFUGGENDO)
sposta(Azione, [ gemma(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    delete(TempMov, gemma(X), NewTempMov),
    sposta(Azione, CodaMovibili, [gemma(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).

sposta(Azione, [ avversario(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    delete(TempMov, avversario(X), NewTempMov),
    sposta(Azione, CodaMovibili, [avversario(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).

%questo serve perche' nei movibili ci sono anche ghiaccio e martello che in realta' NON si muovono, quindi anziche' creare un' altra lista ancora
%ne teniamo solo una che quando trova questi due tipi di oggetti va avanti e basta
sposta(Azione, [ _ | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    sposta(Azione, CodaMovibili, TempMov, TempNuovoStato, NuovoStato, NuoviMovibili).


getPosizioneMartello([martello(X)|_], X).
getPosizioneMartello([_|T], X):- getPosizioneMartello(T, X).