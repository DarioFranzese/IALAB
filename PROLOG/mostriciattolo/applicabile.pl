%CHECK AVVERSARIO SI OCCUPA DI CONTROLLARE CHE SE C' E' UN AVVERSARIO SULLA TRAIETTORIA QUESTO SIA COPERTO DA QUALCHE OSTACOLO.
%CIO' VIENE FATTO ANDANDO A CONTROLLARE UNA POSIZIONE ALLA VOLTA

%MI FERMO PERCHE' HO FINITO IL LABIRINTO
checkAvversario(nord, 1, _).
checkAvversario(ovest, _, 1).
checkAvversario(est, _, C):- num_righe(C).
checkAvversario(sud, R, _):- num_colonne(R).

%MI FERMO PERCHE' HO TROVATO PRIMA UN OSTACOLO CHE L' AVVERSARIO
checkAvversario(_, R, C):- occupata(pos(R,C)).
checkAvversario(_, R, C):- my_gemma(pos(R,C)).
checkAvversario(_, R, C):- my_ghiaccio(pos(R, C)).
checkAvversario(_, R, C):- finale(pos(R, C)).

%MI FERMO E FALLISCO PERCHE' HO TROVATO L' AVVERSARIO PRIMA DI QUALCHE OSTACOLO
checkAvversario(nord, R, C):- avversario(pos(R, C)), fail.

%CHIAMATE RICORSIVE PER PROSEGUIRE LA RICERCA
checkAvversario(nord, R, C):- NR is R-1, checkAvversario(nord, NR, C).
checkAvversario(sud, R, C):- NR is R+1, checkAvversario(nord, NR, C).
checkAvversario(est, R, C):- NC is C+1, checkAvversario(nord, R, NC).
checkAvversario(ovest, R, C):- NC is C-1, checkAvversario(nord, R, NC). 



%applicabile RISULTA ESSERE UN WRAPPER CHE PRIMA CONTROLLA LA CONDIZIONE DELL' AVVERSARIO E POI (eventualmente) LE ALTRE
applicabile(Azione, pos(R, C), Martello):-
    checkAvversario(Azione, R, C, Martello),
    applicabile_2(Azione, pos(R, C), Martello).


%IL TERZO PARAMETRO E' IL MARTELLO (0=NO, 1=SI)
applicabile_2(nord, pos(R, C), 1):- %trovo il ghiaccio ma ho il martello
    R>1,
    NR is R-1,
    my_ghiaccio(pos(NR, C)). %trovo il ghiaccio ma posso romperlo


applicabile_2(nord, pos(R,C), _):- 
    R > 1,
    NR is R-1, 
    \+occupata(pos(NR,C)),
    \+my_ghiaccio(pos(NR,C)), %QUESTA CONDIZIONE NON E' PROBLEMATICA SE HO IL MARTELLO PERCHE' NON POSSONO AVVENIRE ASSIEME ALL' INTERNO DI
                               %DI QUESTO PREDICATO SICCOME VIENE CONTROLLATO PRIMA IL PRECEDENTE, QUINDI SE IL MARTELLO E' 1 DEVE CONTROLALRE SOLO LE ALTRE 2 
    \+my_gemma(pos(NR,C)).

%SUD
applicabile_2(sud, pos(R,C), 1):-
    num_righe(N),
    R < N,
    NR is R+1,
    my_ghiaccio(pos(NR, C)).

applicabile_2(sud, pos(R,C), _):-
    num_righe(N),
    R < N,
    NR is R+1,
    \+occupata(pos(NR, C)),
    \+my_ghiaccio(pos(NR, C)),
    \+my_gemma(pos(NR, C)).

%EST
applicabile_2(est, pos(R,C), 1):-
    num_colonne(N),
    C < N,
    NC is N+1,
    my_ghiaccio(pos(R, NC)).

applicabile_2(est, pos(R,C), _):-
    num_colonne(N),
    C < N,
    NC is C+1,
    \+occupata(pos(R, NC)),
    \+my_ghiaccio(pos(R, NC)),
    \+my_gemma(pos(R, NC)).

%OVEST
applicabile_2(ovest, pos(R,C), 1):-
    C > 1,
    NC is C-1,
    my_ghiaccio(pos(R, NC)).

applicabile_2(ovest, pos(R,C), _):-
    C > 1,
    NC is C-1,
    \+occupata(pos(R, NC)),
    \+my_ghiaccio(pos(R, NC)),
    \+my_gemma(pos(R, NC)).
