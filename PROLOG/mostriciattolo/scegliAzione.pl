miglioriAzioniWrapper(pos(X1,Y1), [martello(pos(X2,Y2)) | _ ], Azioni):-
    priorityMartello,
    X is X2 - X1,
    Y is Y2- Y1,
    miglioriAzioni(X,Y, Azioni).

miglioriAzioniWrapper(pos(X1,Y1), _, Azioni):-
    finale(pos(X2,Y2)),
    X is X2 - X1,
    Y is Y2- Y1,
    miglioriAzioni(X,Y, Azioni).

miglioriAzioni(X,Y,[est, sud, nord, ovest]):-
    abs(X, R1),
    abs(Y, R2),
    R1=<R2,
    X>0,
    Y>0, !.

miglioriAzioni(X,Y,[est, nord, sud, ovest]):-
    abs(X, R1),
    abs(Y, R2),
    R1=<R2,
    X>0,
    Y=<0, !.

miglioriAzioni(X,Y,[ovest, nord, sud, est]):-
    abs(X, R1),
    abs(Y, R2),
    R1=<R2,
    X=<0,
    Y=<0, !.

miglioriAzioni(X,Y,[ovest, sud, nord, est]):-
    abs(X, R1),
    abs(Y, R2),
    R1=<R2,
    X=<0,
    Y>0, !.

miglioriAzioni(X,Y,[sud, est, ovest, nord]):-
    abs(X, R1),
    abs(Y, R2),
    R1>R2,
    Y>0,
    X>0, !.

miglioriAzioni(X,Y,[sud, ovest, est, nord]):-
    abs(X, R1),
    abs(Y, R2),
    R1>R2,
    Y>0,
    X=<0, !.

miglioriAzioni(X,Y,[nord, est, ovest, sud]):-
    abs(X, R1),
    abs(Y, R2),
    R1>R2,
    Y=<0,
    X>0, !.

miglioriAzioni(X,Y,[nord, ovest, est, sud]):-
    abs(X, R1),
    abs(Y, R2),
    R1>R2,
    Y=<0,
    X=<0, !.

scegliAzione(Posizione, Movibili, TempCammino, Azione):-
    miglioriAzioniWrapper(Posizione, Movibili, Azioni),!,
    getAzioneApplicabile(Azioni, Posizione, Movibili, TempCammino, Azione).


getAzioneApplicabile([Testa|_], Posizione, Movibili, TempCammino, Testa):-
    applicabile(Testa, Posizione, Movibili, TempCammino).

getAzioneApplicabile([_|Coda], Posizione, Movibili, TempCammino, Azione):-
    getAzioneApplicabile(Coda, Posizione, Movibili, TempCammino, Azione).
