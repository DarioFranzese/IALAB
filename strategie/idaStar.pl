:- ['../labirinti/labirinto160x160'], ['../utility'], ['../azioni'], ['../visualizza'].

algoritmoIdaStar:-
    iniziale(Start),
    valutazione(Start, [], Soglia),
    wrapperIdaStar(Start, Soglia, [], [], RisultatoReversed),
    reverse(RisultatoReversed, Risultato),
    write(Risultato).

wrapperIdaStar(_, _, Path, _, Path).
wrapperIdaStar(Corrente, Soglia, Path, Visitati, Risultato):-
    idaStar(Corrente, Soglia, Path, Visitati, NuovaSoglia),
    wrapperIdaStar(Corrente, NuovaSoglia, Path, Visitati, Risultato).


idaStar(Corrente, Soglia, Path, Visitati, NextSoglia):-
    length(Path, Lunghezza),
    Lunghezza =< Soglia,!,
    findall(Azione, applicabile(Corrente, Azione), Azioni),
    generaStati(Corrente, Azioni, ),
    
    NextSoglia is Lunghezza + NuovaSoglia, %% f = g+h
    idaStar(NuovoStato, Soglia, [Az | Path], [NuovoStato | Visitati], NextSoglia).

generaStati(_, [], _, Stati).
generaStati(Corrente, [Azione | CodaAzioni ], NuovoStato, Az):-
    trasforma(Azione, Corrente, NuovaPozisione),
    valutazione(NuovaPozisione, [], Costo),
    
    generaStati(Corrente, CodaAzioni, [NuovaPozisione | _]).
    

