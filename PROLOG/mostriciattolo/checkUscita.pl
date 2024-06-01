checkUscita:-
    iniziale(S0),
    dfs(S0, _, []),!.

checkUscita:- write('Dobbiamo prima recuperare il martello'), write('\n'), assert(priorityartello(1)).


dfs(S, [], _):-finale(S), !. 

dfs(S, [Azione| ListaAzioni], Visitati):-
    \+member(S, Visitati), !,
    applicabileCU(Azione, S),
    trasformaCU(Azione, S, SNuovo),
    dfs(SNuovo, ListaAzioni, [S | Visitati]).

applicabileCU(est, pos(Riga, Colonna)):-
    num_colonne(N),
    Colonna < N,
    ColonnaSuccessiva is Colonna+1,
    \+occupata(pos(Riga, ColonnaSuccessiva)),
    \+ghiaccio(pos(Riga, ColonnaSuccessiva)).    

applicabileCU(sud, pos(Riga, Colonna)):-
    num_righe(N),
    Riga < N,
    RigaInferiore is Riga+1, 
    \+occupata(pos(RigaInferiore, Colonna)),
    \+ghiaccio(pos(RigaInferiore, Colonna)).

applicabileCU(nord, pos(Riga, Colonna)):-
    Riga > 1,
    RigaSuperiore is Riga-1,
    \+occupata(pos(RigaSuperiore, Colonna)),
    \+ghiaccio(pos(RigaSuperiore, Colonna)).

applicabileCU(ovest, pos(Riga, Colonna)):-
    Colonna > 1,
    ColonnaPrecedente is Colonna-1,
    \+occupata(pos(Riga, ColonnaPrecedente)),
    \+ghiaccio(pos(Riga, ColonnaPrecedente)).
    

    trasformaCU(est, pos(Riga, Colonna), pos(Riga, NuovaColonna)):- NuovaColonna is Colonna+1.
    trasformaCU(ovest, pos(Riga, Colonna), pos(Riga, NuovaColonna)):- NuovaColonna is Colonna-1.
    trasformaCU(sud, pos(Riga, Colonna), pos(NuovaRiga, Colonna)):- NuovaRiga is Riga+1.
    trasformaCU(nord, pos(Riga, Colonna), pos(NuovaRiga, Colonna)):- NuovaRiga is Riga-1.
