:- ['../labirinti/labirinto160x160'], ['../utility'], ['../azioni'], ['../visualizza'].

algoritmoIdaStar:-
    iniziale(Start),
    valutazione(Start, [], Soglia),
    wrapperIdaStar(Start, Soglia, [], [], RisultatoReversed),
    reverse(RisultatoReversed, Risultato),
    write(Risultato).

wrapperIdaStar(Corrente, Soglia, Path, Visitati, Risultato):-
    idaStar(Corrente, Soglia, Path, Visitati, Risultato, NuovaSoglia),
    wrapperIdaStar(Corrente, NuovaSoglia, Path, Visitati, Risultato).


idaStar(Corrente, Soglia, Path, Visitati, Risultato, NextSoglia):-
    length(Path, Lunghezza),
    Lunghezza =< Soglia,!,
    findall(Azione, applicabile(Corrente, Azione), Azioni),
    generaStati(Corrente, Azioni, NuovoStato, NuovaSoglia), % Qui istanziato NextSoglia
    NextSoglia is Lunghezza + NuovaSoglia.
    trasforma

generaStati(Corrente, [Azione | CodaAzioni ], NuovoStato, NextSoglia):-
    trasforma(Azione, Corrente, NuovaPozisione),
    valutazione(Corrente, Path, Valutazione)
    

