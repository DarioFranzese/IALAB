:- ['../labirinti/labirinto160x160'], ['../utility'], ['../azioni'], ['../visualizza'].

ricerca(Cammino):-
    iniziale(S0),
    valutazione(S0, [], Soglia),
    assert(euristicaMinima(Soglia)),
    wrapperRicProf(S0, Soglia, Cammino),
    write('\nIl risultato e' ), write(Cammino), write('\n '), 
    write('La lunghezza e '), length(Cammino, Int), write(Int).

%% Ricerca in profondità

wrapperRicProf(StatoIniziale, Soglia, Cammino):- ric_prof(StatoIniziale, Soglia, [], Cammino), !.

/*
wrapperRicProf(StatoIniziale, Soglia, Cammino):- %Soglia era dontcare
    NuovaSoglia is Soglia +1, %per semplificare il debug
    write('\nNuova Soglia: '), write(NuovaSoglia),write('\n'),
    limite(Limite),
    Limite > NuovaSoglia,!, %Controllo sul massimo della soglia

    wrapperRicProf(StatoIniziale, NuovaSoglia, Cammino). %la lista vuota sono i visitati
*/

%% CASO BASE
ric_prof(S, _, _, []):- 
    finale(S),!.

%% PASSO INDUTTIVO
ric_prof(Corrente, Soglia, Visitati, [NuovaAzione | SeqAzioni]):-
    write('\nCorrente: '), write(Corrente), write('\n'),
    Soglia > 0,!,
    findall(Az, applicabile(Az, Corrente), Azioni),
    limite(Limite), %da cambiare 
    generaStato(Azioni, Corrente, Visitati, _, NuovoStato, _, NuovaAzione, Limite),    %Si noti che "Cammino" di generaStati in realta' e' Visitati,
                                                                    % irrilevante in quanto quell' informazione viene usata solo 
                                                                    %per calcolare la lunghezza che e' la stessa
    NuovaSoglia is Soglia -1,
    ric_prof(NuovoStato, NuovaSoglia, [Corrente | Visitati], SeqAzioni).

%in genera stato bisogna vedere se si possono aggiungere dei dontcare (tra i temp... e i Nuovo...)
%Caso base
%se il nuovo minimo e' <= della soglia allora si rompe (va in loop). Bisogna gestire questa cosa.
generaStato([], _, _, NuovoStato, NuovoStato, NuovaAzione, NuovaAzione, Minimo):-
    write('1\n'),
    retractall(euristicaMinima(_)),
    assert(euristicaMinima(Minimo)). %Sostituisce 124 con 124 e va in loop


%Caso in cui il nuovo stato generato e' il minimo, aggiorno l' euristica
generaStato([Azione | CodaAzioni], Corrente, Cammino, _, NuovoStato, _, NuovaAzione, Minimo):- %Temp qui e' un dontcare perche' viene sovrascritto da Stato
    
    trasforma(Azione, Corrente, Stato),
    \+member(Stato, Cammino), %% PREDICATO AUSILIARO PER MEMEBER QUI
    
    valutazione(Stato, Cammino, Risultato),
    Minimo > Risultato,!, %quando fallisce qui non arriva al caso base e va in loop perche' non aggiorna la soglia
    writeln('2\n'),
    generaStato(CodaAzioni, Corrente, Cammino,  Stato, NuovoStato, Azione, NuovaAzione, Risultato).

%Caso in cui il nuovo stato generato NON e' il minimo oppure lo stato gia' era presente nei visitati (insomma deve essere scartato)
%qua ci possono andare tantissimi dontcares
generaStato([_ | CodaAzioni], Corrente, Cammino, TempStato, NuovoStato, TempAzione, NuovaAzione,  Minimo):- %NuovaAzione dontcare?
    write('3\n'),
    generaStato(CodaAzioni, Corrente, Cammino,  TempStato, NuovoStato, TempAzione, NuovaAzione, Minimo), !.






