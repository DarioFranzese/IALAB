:- ['../labirinti/labFacile'], ['../utility'], ['../azioni'], ['../visualizza'].

ricerca(Cammino, Soglia):-
    iniziale(S0),
    wrapperRicProf(S0, Soglia, Cammino),
    write(Cammino).

%% Ricerca in profondità

wrapperRicProf(StatoIniziale, Soglia, Cammino):- ric_prof(StatoIniziale, Soglia, [], Cammino),!.

wrapperRicProf(StatoIniziale, Soglia, Cammino):-
    NuovaSoglia is Soglia +1,
    %Qui andrebbe aggiunto il controllo sul massimo della soglia
    wrapperRicProf(StatoIniziale, NuovaSoglia, Cammino). %la lista vuota sono i visitati


%% CASO BASE
ric_prof(S, _, _, []):- 
    finale(S),!.

%% PASSO INDUTTIVO
ric_prof(Corrente, Soglia, Visitati, [Az | SeqAzioni]):-
    Soglia > 0,!,
    findall(Az, applicabile(Az, Corrente), Azioni),
    generaStato(Azioni, Corrente, SeqAzioni, NuovoStato),
    NuovaSoglia is Soglia -1,
    ric_prof(NuovoStato, NuovaSoglia, [Corrente | Visitati], SeqAzioni).


generaStato([], _, _, NuovoStato).

generaStato([Azione | CodaAzioni], Corrente, Cammino, NuovoStato):-
    trasforma(Azione, Corrente, Stato),
    valutazione(Stato, Cammino, Risultato),
    write("\nRisultato e "), write(Risultato).




