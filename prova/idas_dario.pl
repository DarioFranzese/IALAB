:- ['../labirinti/hard20x20'], ['../utility'], ['../azioni'], ['../visualizza'].

ricerca(Cammino):-
    iniziale(S0),
    valutazione(S0, [], Soglia),

    limite(Limite),
    assert(euristicaMinima(Limite)), %alla prima iterazione non mi serve salvare Soglia
                                    %quindi inserisco direttamente limite per permettere i confronti 
                                    %dei minimi locali (vedi piu' avanti per maggiore chiarezza)

    wrapperRicProf(S0, Soglia, Cammino),
    write('\nIl risultato e' ), write(Cammino), write('\n '), 
    write('La lunghezza e '), length(Cammino, Int), write(Int).


%%CASO BASE
wrapperRicProf(StatoIniziale, Soglia, Cammino):- ric_prof(StatoIniziale, Soglia, [], Cammino), !.

%%CASO DI FALLIMENTO, AGGIORNAMENTO DELLA SOGLIA
wrapperRicProf(StatoIniziale, _, Cammino):-
    euristicaMinima(NuovaSoglia),    
    write('\nNuova Soglia: '), write(NuovaSoglia),write('\n'),
    limite(Limite),
    Limite > NuovaSoglia,!, %Controllo sul massimo della soglia

    retractall(euristicaMinima(_)),
    assert(euristicaMinima(Limite)), %Dopo aver settato la soglia devo permettere alla prossima
                                    %iterazione di trovarmi il nuovo minimo LOCALE che pero´sara maggiore
                                    %della soglia, quindi una volta salvata la soglia per l' iterazione
                                    %setto euristicaMinima al massimo cosi' che potro' salvarmi
                                    %il nuovo minimo (mi serve principalmente per il primo confronto)
    wrapperRicProf(StatoIniziale, NuovaSoglia, Cammino).


%% CASO BASE
ric_prof(S, _, _, []):- 
    finale(S),!.

%caso in cui la soglia e' 0 quindi bisogna aggiornare la soglia
%ho capito che la soglia deve tenere in considerazione solo i nodi terminali (quindi Soglia=0)
%andava in loop perche' giustamente la soglia minima e' sempre quella dello start
ric_prof(Corrente, 0, Visitati, _):- !,
    valutazione(Corrente, Visitati, Risultato),
    euristicaMinima(Minimo),
    retractall(euristicaMinima(_)),
    NuovoMinimo is min(Minimo, Risultato),
    assert(euristicaMinima(NuovoMinimo)),
    fail.

%% PASSO INDUTTIVO
ric_prof(Corrente, Soglia, Visitati, [NuovaAzione | SeqAzioni]):-
    Soglia > 0,!,
    \+member(Corrente, Visitati),!,
    applicabile(NuovaAzione, Corrente), 
    trasforma(NuovaAzione, Corrente, NuovoStato),

    NuovaSoglia is Soglia -1,
    ric_prof(NuovoStato, NuovaSoglia, [Corrente | Visitati], SeqAzioni).