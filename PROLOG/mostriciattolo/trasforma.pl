%LA QUARTA VARIABILE E' IL MARTELLO

%IL PREDICATO SPOSTA E' PENSATO PER QUANDO SI MUOVE L' AGENTE, TUTTAVIA SI PUO' UTILIZZARE ANCHE QUANDO SI MUOVONO LE ALTRE ENTITA', BASTA TRATTARLE COME
%AGENTI SENZA MARTELLO (va solo capito che succede se finiscono sul finale o sul martello, dipende quanto vogliamo riutilizzare il codice)

%CASO BASE IN CUI SONO ARRIVATO AL FINALE
sposta(_, pos(R, C), pos(R, C), _):- finale(pos(R,C)).

%NORD

%CASO BASE SONO ARRIVATO ALLA FINE DEL LABIRINTO
sposta(nord, pos(1, C), pos(1, C), _).

%CASO BASE SONO ARRIVATO AD UN OSTACOLO
sposta(nord, pos(R,C), pos(R,C), 0):- my_ghiaccio(pos(R-1, C)).
sposta(nord, pos(R,C), pos(R,C), _):- my_gemma(pos(R-1, C)).
sposta(nord, pos(R,C), pos(R,C), _):- occupata(pos(R-1, C)).

%SE TROVO IL MARTELLO LO PRENDO, FORSE VA GESTITA LA VARIABILE DI RITORNO DEL MARTELLO (SICURO TOGLIENDO QUALCHE DONTCARE)
sposta(nord, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    sposta(nord, pos(R-1, C), pos(RNuovo, CNuovo), 1).


%CASO IN CUI TROVO IL GHIACCIO MA HO IL MARTELLO, RIMUOVO IL GHIACCIO CHE AVEVO "INSERITO LOCALMENTE"
sposta(nord, pos(R, C), pos(RNuovo, CNuovo), 1):-
    my_ghiaccio(pos(R-1, C)),
    retract(my_ghiaccio(pos(R-1, C))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(nord, pos(R-1, C), pos(RNuovo, CNuovo), 1).

%CASO RICORSIVO STANDARD
sposta(nord, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    sposta(nord, pos(R-1, C), pos(RNuovo, CNuovo), Martello).
    

%SUD
sposta(sud, pos(R, C), pos(R, C), _):- num_righe(R).

sposta(sud, pos(R,C), pos(R,C), 0):- my_ghiaccio(pos(R+1, C)).
sposta(sud, pos(R,C), pos(R,C), _):- my_gemma(pos(R+1, C)).
sposta(sud, pos(R,C), pos(R,C), _):- occupata(pos(R+1, C)).

sposta(sud, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    sposta(sud, pos(R+1, C), pos(RNuovo, CNuovo), 1).

sposta(sud, pos(R, C), pos(RNuovo, CNuovo), 1):-
    my_ghiaccio(pos(R+1, C)),
    retract(my_ghiaccio(pos(R+1, C))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(sud, pos(R+1, C), pos(RNuovo, CNuovo), 1).

sposta(sud, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    sposta(sud, pos(R+1, C), pos(RNuovo, CNuovo), Martello).

%EST
sposta(est, pos(R, C), pos(R, C), _):- num_colonne(C).

sposta(est, pos(R,C), pos(R,C), 0):- my_ghiaccio(pos(R, C+1)).
sposta(est, pos(R,C), pos(R,C), _):- my_gemma(pos(R+1, C+1)).
sposta(est, pos(R,C), pos(R,C), _):- occupata(pos(R+1, C+1)).

sposta(est, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    sposta(est, pos(R, C+1), pos(RNuovo, CNuovo), 1).

sposta(est, pos(R, C), pos(RNuovo, CNuovo), 1):-
    my_ghiaccio(pos(R, C+1)),
    retract(my_ghiaccio(pos(R, C+1))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(est, pos(R, C+1), pos(RNuovo, CNuovo), 1).

sposta(est, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    sposta(est, pos(R, C+1), pos(RNuovo, CNuovo), Martello).


%OVEST
sposta(ovest, pos(R, 1), pos(R, 1), _).

sposta(ovest, pos(R,C), pos(R,C), 0):- my_ghiaccio(pos(R, C-1)).
sposta(ovest, pos(R,C), pos(R,C), _):- my_gemma(pos(R+1, C-1)).
sposta(ovest, pos(R,C), pos(R,C), _):- occupata(pos(R+1, C-1)).

sposta(ovest, pos(R,C), pos(RNuovo,CNuovo), 0):-
    my_martello(pos(R,C)),
    retract(my_martello(pos(R,C))),
    sposta(ovest, pos(R, C-1), pos(RNuovo, CNuovo), 1).

sposta(ovest, pos(R, C), pos(RNuovo, CNuovo), 1):-
    my_ghiaccio(pos(R, C-1)),
    retract(my_ghiaccio(pos(R, C-1))), %DA CONTROLLARE QUESTA SINTASSI
    sposta(ovest, pos(R, C-1), pos(RNuovo, CNuovo), 1).

sposta(ovest, pos(R, C), pos(RNuovo, CNuovo), Martello):-
    sposta(ovest, pos(R, C-1), pos(RNuovo, CNuovo), Martello).

