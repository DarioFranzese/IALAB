

/*
L' IDEA E' CHE TRASFORMA PRENDA IN INPUT LA POSIZIONE CORRENTE, I MOVIBILI E CHE ORDINI LA POSIZIONE DI TUTTI QUESTI IN MODO DA DETERMINARE L' ORDINE
CON IL QUALE VENGONO CALCOLATI I SINGOLI SPOSTAMENTI. PER FARE CIO', IL PREDICATO DI SPOSTAMENTO HA SEMPRE I MOVIBILI PER CONOSCERE GLI OSTACOLI ETC. MA 
INOLTRE PER CAPIRE QUALE POSIZIONE E' ASSOCIATA A CHE TIPO DI SOGGETTO SI STIA SPOSTANDO (OSTACOLO O CORRENTE) SI POSSONO FARE 4 WRAPPER (UNO PER OGNI TIPO DI MOVIBILE)
DOVE 3 CHIAMERANNO UNA VERSIONE DI SPOSTA CHE CONSIDERA MARTELLO E GEMMA COME OSTACOLI, L' ALTRA (QUELLA IMPLEMENTATA DA MODIFICARE) E' PER L' AGENTE CHE QUINDI PUO' MODIFICARE I MOVIBILI (CHE DOVRANNO
ESSERE LA QUARTA VARIABILE, STESSA MODIFICA FATTA IN APPLICABILE). QUESTA COSA UN PO' MACCHINOSA E' DOVUTA AL FATTO CHE L' ALTERNATIVA SAREBBE DUPLICARE OGNI
PREDICATO DI SPOSTAMENTO PER OGNI TIPO DI OGGETTO (agente, avversario, gemma, martello) MENTRE INVECE COSI' FACENDO NE CREIAMO SOLO DUE (uno per l' agente e
uno per gli ostacoli) CHE VERRANNO CHIAMATI DAL FAMOSO WRAPPER.
A questi predicati quindi va cambiata l' ultima variabile in "Movibili" e aggiungerne una che sara' "NuoviMovibili"


%CASO BASE IN CUI SONO ARRIVATO AL FINALE
sposta(_, pos(R, C), pos(R, C), _):- finale(pos(R,C)).

%NORD

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
sposta(nord, pos(1, C), pos(1, C), Movibile).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
sposta(nord, pos(R,C), pos(R,C), 0):- NR is R-1, my_ghiaccio(pos(NR, C)).
sposta(nord, pos(R,C), pos(R,C), _):- NR is R-1,my_gemma(pos(NR, C)).
sposta(nord, pos(R,C), pos(R,C), _):- NR is R-1,occupata(pos(NR, C)).

%SE TROVO IL MARTELLO LO PRENDO, FORSE VA GESTITA LA VARIABILE DI RITORNO DEL MARTELLO (SICURO TOGLIENDO QUALCHE DONTCARE)
sposta(nord, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NR is R-1,
    sposta(nord, pos(NR, C), pos(RNuovo, CNuovo), 1).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO CHE AVEVO "INSERITO LOCALMENTE"
sposta(nord, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NR is R-1,
    my_ghiaccio(pos(NR, C)),
    retract(my_ghiaccio(pos(NR, C))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(nord, pos(NR, C), pos(RNuovo, CNuovo), 1).

%CASO RICORSIVO STANDARD
sposta(nord, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    NR is R-1,
    sposta(nord, pos(NR, C), pos(RNuovo, CNuovo), Martello).
    

%SUD
sposta(sud, pos(R, C), pos(R, C), _):- num_righe(R).

sposta(sud, pos(R,C), pos(R,C), 0):- NR is R+1, my_ghiaccio(pos(NR, C)).
sposta(sud, pos(R,C), pos(R,C), _):- NR is R+1, my_gemma(pos(NR, C)).
sposta(sud, pos(R,C), pos(R,C), _):- NR is R+1, occupata(pos(NR, C)).

sposta(sud, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NR is R+1,
    sposta(sud, pos(NR, C), pos(RNuovo, CNuovo), 1).

sposta(sud, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NR is R+1,
    my_ghiaccio(pos(NR, C)),
    retract(my_ghiaccio(pos(NR, C))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(sud, pos(NR, C), pos(RNuovo, CNuovo), 1).

sposta(sud, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    NR is R+1,
    sposta(sud, pos(NR, C), pos(RNuovo, CNuovo), Martello).

%EST
sposta(est, pos(R, C), pos(R, C), _):- num_colonne(C).

sposta(est, pos(R,C), pos(R,C), 0):- NC is C+1, my_ghiaccio(pos(R, NC)).
sposta(est, pos(R,C), pos(R,C), _):- NC is C+1, my_gemma(pos(R, NC)).
sposta(est, pos(R,C), pos(R,C), _):- NC is C+1, occupata(pos(R, NC)).

sposta(est, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NC is C+1,
    sposta(est, pos(R, NC), pos(RNuovo, CNuovo), 1).

sposta(est, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NC is C+1,
    my_ghiaccio(pos(R, NC)),
    retract(my_ghiaccio(pos(R, NC))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(est, pos(R, NC), pos(RNuovo, CNuovo), 1).

sposta(est, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    NC is C+1,
    sposta(est, pos(R, NC), pos(RNuovo, CNuovo), Martello).


%OVEST
sposta(ovest, pos(R, 1), pos(R, 1), _).

sposta(ovest, pos(R,C), pos(R,C), 0):- NC is C-1, my_ghiaccio(pos(R, NC)).
sposta(ovest, pos(R,C), pos(R,C), _):- NC is C-1, my_gemma(pos(R, NC)).
sposta(ovest, pos(R,C), pos(R,C), _):- NC is C-1, occupata(pos(R, NC)).

sposta(ovest, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    NC is C-1,
    sposta(ovest, pos(R, NC), pos(RNuovo, CNuovo), 1).

sposta(ovest, pos(R, C), pos(RNuovo, CNuovo), 1):-
    NC is C-1,
    my_ghiaccio(pos(R, NC)),
    retract(my_ghiaccio(pos(R, NC))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(ovest, pos(R, NC), pos(RNuovo, CNuovo), 1).

sposta(ovest, pos(R, C), pos(RNuovo, CNuovo), Movibili):-
    NC is C-1,
    sposta(ovest, pos(R, NC), pos(RNuovo, CNuovo), Movibili).

*/

trasforma(Azione, Corrente, Movibili, NuovoStato, NuoviMovibili):-
    ordina(Azione, [corrente(Corrente) | Movibili], MovibiliOrdinati), %il predicato corrente verra' usato per identificare l' agente
    sposta(Azione, MovibiliOrdinati, MovibiliOrdinati, _, NuovoStato, NuoviMovibili). %questo wrapper prendera' un movibile alla volta e lo spostera', restituendo poi i NuoviMovibili (potenzialmente prendiamo il martello
                                                                        %oppure rompiamo il ghiaccio) e il nuovo stato dell' agente
                                                                        %quello che sopra e' chiamato sposta sara' spostaAgente, andra' poi fatto spostaOggetto.
                                                                        

%CASO BASE
sposta(_, [], NuoviMovibili, NuovoStato, NuovoStato, NuoviMovibiliSenzaCorrente):-  removeFromList(NuoviMovibili, corrente(_), NuoviMovibiliSenzaCorrente). %i NuoviMovibili hanno al loro interno anche il corrente
                                                                                                                                                %ma noi non lo vogliamo quindi lo tolgo.
                                                                                                                                                %In realta' questa cosa si potrebbe anche modificare lasciandolo
                                                                                                                                                %sempre dentro. Sarebbe una copia del corrente non mi fa impazzire
                                                                                                                                                %come cosa                                                                       

sposta(Azione, [ corrente(X) | CodaMovibili], TempMov, _, NuovoStato, NuoviMovibili):-
    spostaAgente(Azione, X, TempMov, NuovoStatoAgente, MovibiliPostAgente), %questo e' l'unico predicato che dovra' modificare NuovoStato
    removeFromList(MovibiliPostAgente, corrente(X), NuovaCodaMovibili), %Movibili post agente sara' l' elenco dei movibili potenzialmente primo di ghiaccio e martello, tuttavia contiene ancora la posizione
                                                                       %del corrente, che va quindi tolta per poi aggiungerci il nuovo corrente
    sposta(Azione, CodaMovibili, [corrente(NuovoStato) | NuovaCodaMovibili], NuovoStatoAgente, NuovoStato, NuoviMovibili). %metto il corrente in testa tanto e' indifferente
                                                                                                         %Occhio All' utilizzo di NuovoStato non mi convince


sposta(Azione, [ gemma(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    removeFromList(TempMov, gemma(X), NewTempMov),
    sposta(Azione, CodaMovibili, [gemma(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).

sposta(Azione, [ avversario(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    removeFromList(TempMov, avversario(X), NewTempMov),
    sposta(Azione, CodaMovibili, [avversario(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).