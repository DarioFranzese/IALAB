:- ['../labirinti/labirintoProf'], ['../utility'], ['../azioni'], ['../visualizza'].

ricerca(Cammino):-
    iniziale(S0),
    valutazione(S0, [], Soglia),
    assert(euristicaMinima(Soglia)),
    write('\nEuristica minima: '), write(Soglia), write('\n'),
    wrapperRicProf(S0, Soglia, Cammino),
    write('\nIl risultato e' ), write(Cammino), write('\n ').

%% Ricerca in profondità

wrapperRicProf(StatoIniziale, Soglia, Cammino):- ric_prof(StatoIniziale, Soglia, [], Cammino),!.

wrapperRicProf(StatoIniziale, _, Cammino):-
    euristicaMinima(NuovaSoglia),
    write('\nNuova Soglia: '), write(NuovaSoglia),write('\n'),
    limite(Limite),
    Limite > NuovaSoglia,!,
                        %Qui andrebbe aggiunto il controllo sul massimo della soglia

    wrapperRicProf(StatoIniziale, NuovaSoglia, Cammino). %la lista vuota sono i visitati


%% CASO BASE
ric_prof(S, _, _, []):- 
    finale(S),!.

%% PASSO INDUTTIVO
ric_prof(Corrente, Soglia, Visitati, [Azione | SeqAzioni]):-
    Soglia > 0,!,
    findall(Az, applicabile(Az, Corrente), Azioni),
    limite(Limite), %limite qui viene usato come massimo intero per il calcolo dell' euristica, l' euristica e' sempre inferiore a questo valore quindi va bene
    generaStato(Azioni, Corrente, Visitati, _, NuovoStato, _, Azione, Limite),    %Si noti che "Cammino" di generaStati in realta' e' Visitati,
                                                                    % irrilevante in quanto quell' informazione viene usata solo 
                                                                    %per calcolare la lunghezza che e' la stessa
    write('\nNuovo Stato: '), write(NuovoStato),
    NuovaSoglia is Soglia -1,
    ric_prof(NuovoStato, NuovaSoglia, [Corrente | Visitati], SeqAzioni).

%in genera stato bisogna vedere se si possono aggiungere dei dontcare (tra i temp... e i Nuovo...)
%Caso base
generaStato([], _, _, NuovoStato, NuovoStato, NuovaAzione, NuovaAzione, Minimo):- 
    retractall(euristicaMinima(_)),
    assert(euristicaMinima(Minimo)).

%Caso in cui il nuovo stato generato e' il minimo, aggiorno l' euristica
generaStato([Azione | CodaAzioni], Corrente, Cammino, _, NuovoStato, _, NuovaAzione, Minimo):- %Temp qui e' un dontcare perche' viene sovrascritto da Stato
    trasforma(Azione, Corrente, Stato),
    valutazione(Stato, Cammino, Risultato),
    Minimo > Risultato,!,
    generaStato(CodaAzioni, Corrente, Cammino,  Stato, NuovoStato, Azione, NuovaAzione, Risultato).

%Caso in cui il nuovo stato generato NON e' il minimo
generaStato([Azione | CodaAzioni], Corrente, Cammino, TempStato, NuovoStato, TempAzione, NuovaAzione,  Minimo):- %NuovaAzione dontcare?
    trasforma(Azione, Corrente, Stato),
    valutazione(Stato, Cammino, Risultato),
    Minimo =< Risultato,!,
    generaStato(CodaAzioni, Corrente, Cammino,  TempStato, NuovoStato, TempAzione, NuovaAzione, Minimo).






