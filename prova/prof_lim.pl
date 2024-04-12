:-["9_labirinto.pl"], ["9_azioni.pl"].


ricerca(Cammino,Soglia):-
    iniziale(S0),
    wrapper(S0,Soglia,[],Cammino),
    write(Cammino).
    %ric_prof(S0,NuovaSoglia,[],Cammino),!.

wrapper(Stato, _, _, _):-
    finale(Stato), !.

wrapper(Stato, Soglia, Visitati, Cammino):-
    \+ric_prof(Stato, Soglia, Visitati, Cammino),
    NewSoglia is Soglia + 1,
    wrapper(Stato, NewSoglia, Visitati, Cammino).
/*
ricerca(Cammino, Soglia):- 
    NuovaSoglia is Soglia +1,
    ricerca(Cammino, NuovaSoglia).
*/

ric_prof(S,_,_,[]):-finale(S),!.
ric_prof(S,Soglia,Visitati,[Az|SeqAzioni]):-
    Soglia > 0,
    applicabile(Az,S),
    trasforma(Az,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    ric_prof(SNuovo,NuovaSoglia,[S|Visitati],SeqAzioni).
