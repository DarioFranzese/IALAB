:- ['../labirinti/labirintoProf'], ['../azioni'], ['../utility'], ['../visualizza'].

ida:-
    iniziale(Start),
    wrapperRic(Start, Cammino), !,
    reverse(Cammino, Reversed),
    write(Reversed).

wrapperRic(Stato, Cammino):-
    valutazione(Stato, Cammino, Costo),
    assert(sogliaPrecedente(Costo)),
    assert(euristicaMinima(Costo)),
    write("\nSoglia Iniziale: "), write(Costo), write("\n"),
    ricercaCammino(Stato, Costo, [], Cammino).


ricercaCammino(Stato, 0, _, Cammino):- 
    finale(Stato), !, 
    write("\n\nCammino: "), 
    write(Cammino), 
    write("\n\n"), 
    write("\n\nStato Finale: "), write(Stato), write("\n\n"). 

ricercaCammino(_, 0, _, _):- 
    iniziale(Start),
    euristicaMinima(Costo),
    valutazione(Start, [], Val),
    Soglia is Costo + Val,
    sogliaPrecedente(VecchiaSoglia),
    Soglia > VecchiaSoglia,!,
    
    limite(Limite),
    Soglia =< Limite,!,

    retractall(euristicaMinima(_)), retractall(sogliaPrecedente(_)),
    assert(euristicaMinima(Soglia)),
    assert(sogliaPrecedente(Soglia)),

    write("\nSoglia Nuova: "), write(Soglia), write("\n"),
    ricercaCammino(Start, Soglia, [], []).

ricercaCammino(_, 0, _, _):- 
    iniziale(Start),
    euristicaMinima(Costo),
    valutazione(Start, [], Val),
    Soglia is Costo + Val,
    sogliaPrecedente(VecchiaSoglia),
    Soglia =< VecchiaSoglia,!,
    NewSoglia is VecchiaSoglia +1,

    limite(Limite),
    NewSoglia =< Limite,!,

    retractall(euristicaMinima(_)), retractall(sogliaPrecedente(_)),
    assert(euristicaMinima(NewSoglia)),
    assert(sogliaPrecedente(NewSoglia)),

    write("\nSoglia Nuova: "), write(NewSoglia), write("\n"),
    ricercaCammino(Start, NewSoglia, [], []).


ricercaCammino(Stato, Soglia, Visitati, Cammino):-
    findall(Azione, applicabile(Azione, Stato), Azioni),
    generaStato(Stato, Azioni, [], Visitati, Cammino, [NuovoStato, NuovaAzione, CostoAzione]),
    euristicaMinima(Min),
    Minimo is min(CostoAzione, Min),
    retractall(euristicaMinima(_)),
    assert(euristicaMinima(Minimo)),
    write("\nNuovoStato: "), write(NuovoStato), write("\n"),
    NuovaSoglia is Soglia - 1, 
    ricercaCammino(NuovoStato, NuovaSoglia, [NuovoStato | Visitati], [NuovaAzione | Cammino]).
/*
ricercaCammino(Stato, _, Visitati, Cammino):-
    findall(Azione, applicabile(Azione, Stato), Azioni),
    generaStato(Stato, Azioni, [], Visitati, Cammino, [NuovoStato, NuovaAzione, CostoAzione]),
    euristicaMinima(Min),
    Minimo is min(CostoAzione, Min),
    retractall(euristicaMinima(_)),
    assert(euristicaMinima(Minimo)),
    member(NuovoStato, Visitati),
    ricercaCammino(NuovoStato, 0, Visitati, [NuovaAzione | Cammino]).
*/

generaStato(_, [], StatiCosto, _, _, NuovoStato):-
    trovaMinimo(StatiCosto, NuovoStato).
    %generaStato(_, [], [], NuovoStato).

generaStato(Stato, [Azione | CodaAzioni], StatiCosto, Visitati, Cammino, NuovoStato):-
    trasforma(Azione, Stato, NuovaPosizione),
    \+member(NuovaPosizione, Visitati), !,
    valutazione(NuovaPosizione, Cammino, CostoAzione),
    generaStato(Stato, CodaAzioni, [[NuovaPosizione, Azione, CostoAzione] | StatiCosto], Visitati, Cammino, NuovoStato).

generaStato(Stato, [_ | CodaAzioni], StatiCosto, Visitati, Cammino, NuovoStato):-
    generaStato(Stato, CodaAzioni, StatiCosto, Visitati, Cammino, NuovoStato).


% Predicato per trovare l'elemento con il costo minimo
trovaMinimo([[Stato, Azione, Costo] | StatiCosto], Minimo) :-
    trovaMinimo(StatiCosto, [Stato, Azione, Costo], Minimo).

% Caso base: quando la lista è vuota, restituisci l'elemento con il costo minimo trovato finora
trovaMinimo([], Minimo, Minimo).

% Caso ricorsivo: confronta il costo corrente con il costo minimo trovato finora
trovaMinimo([[Stato, Azione, Costo] | Resto], [_, _, CostoMinimoCorrente], Minimo) :-
    Costo < CostoMinimoCorrente, !,
    trovaMinimo(Resto, [Stato, Azione, Costo], Minimo).

% Se il costo corrente non è minore, continua con l'elemento con il costo minimo trovato finora
trovaMinimo([[_, _, _] | Resto], CostoMinimoCorrente, Minimo) :-
    trovaMinimo(Resto, CostoMinimoCorrente, Minimo).


