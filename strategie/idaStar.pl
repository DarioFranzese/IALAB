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
    generaStati(Corrente, Azioni, Visitati, NuovoStato, Azione, CostoEuristica),
    NextSoglia is Lunghezza + CostoEuristica, %% f = g+h
    idaStar(NuovoStato, Soglia, [Azione | Path], Visitati, NextSoglia).

generaStati(_, [], _, _, _, _).
generaStati(Corrente, [Azione | CodaAzioni ], Visitati, NuovaPozisione, Azione, CostoEuristica):-
    trasforma(Azione, Corrente, NuovaPozisione),
    \+member(NuovaPozisione, Visitati), !,
    valutazione(NuovaPozisione, [], CE),
    CostoEuristica1 is min(CostoEuristica, CE),
    generaStati(Corrente, CodaAzioni, [NuovaPozisione | Visitati], NuovaPozisione, Azione, CostoEuristica1).
    






