:- ['/labirinti/mostriciattolo1'], ['/utility'], ['applicabile'], ['/sposta'], ['/trasforma'], ['../visualizza'], ['/checkUscita'].

ricerca:-
    iniziale(S0),
    movibili(Movibili), %prenda la lista degli oggtti movibili (ghiaccio, emme, avversario, martello), le rimuove e le salva sempre nello stato corrente (per modificarle)
%    checkUscita(), %Controlla che l' uscita sia libera. Se no, forzera' l' euristica ad andare prima sul martello (asserendo un predicato di controllo, valido sempre, che avra' come semantica "se non 
                   %hai ancora preso il martello, vai prima li")
    %checkUscita funziona, per il momento e' mutato per facilitare il debug.
    valutazione(S0, [], Movibili, Soglia),

    limite(Limite),
    LimiteSuperiore is Limite*2, %Il vero limite adesso e' due volte il limite visto che il martello parte da Limite+manhattan.
    assert(euristicaMinima(LimiteSuperiore)),


    write('Soglia iniziale: '), write(Soglia), write('\n'),
    write('Limite: '), write(Limite), write('\n'),

    wrapperRicProf((S0, Movibili), Soglia, Cammino), 
    %bisogna fare il reverse del cammino
    write('\nIl risultato e' ), write(Cammino), write('\n '), 
    write('La lunghezza e '), length(Cammino, Int), write(Int), write('\n '),
    visualizza_labirinto.



%%CASO BASE
wrapperRicProf((Corrente, Movibili), Soglia, Cammino):- ric_prof((Corrente, Movibili), Soglia, [], [], Cammino), !.

%%CASO DI FALLIMENTO, AGGIORNAMENTO DELLA SOGLIA
wrapperRicProf((Corrente, Movibili), _, Cammino):-
    euristicaMinima(NuovaSoglia),    
    write('\nNuova Soglia: '), write(NuovaSoglia),write('\n'),
    limite(Limite), 
    LimiteSuperiore is Limite*2, %Il vero limite adesso e' due volte il limite visto che il martello parte da Limite+manhattan.
    LimiteSuperiore > NuovaSoglia,

    retractall(euristicaMinima(_)),
    assert(euristicaMinima(LimiteSuperiore)), %Dopo aver settato la soglia devo permettere alla prossima
                                                %iterazione di trovarmi il nuovo minimo LOCALE che pero´sara maggiore
                                                %della soglia, quindi una volta salvata la soglia per l' iterazione
                                                %setto euristicaMinima al massimo cosi' che potro' salvarmi
                                                %il nuovo minimo (mi serve principalmente per il primo confronto)
    wrapperRicProf((Corrente, Movibili), NuovaSoglia, Cammino).



%% CASO BASE
ric_prof((S, _), _, _, Cammino, Cammino):- %in realta' questo dovrebbe controllare anche Soglia>0, ma io me ne sbatterei allegramente il cazzo. Comporterebbe solo un' iterazione in piu.
    finale(S),!.


%% CASO SOGLIA SFORATA (siccome decremento di >=1 potrebbe essere negativa)
ric_prof((Corrente, Movibili), Soglia, Visitati, _, _):-
    Soglia<0,!,
    write(Corrente), write('Ho sforato la soglia\n'),
    valutazione(Corrente, Visitati, Movibili, Risultato),
    euristicaMinima(Minimo),
    retractall(euristicaMinima(_)),
    NuovoMinimo is min(Minimo, Risultato),
    assert(euristicaMinima(NuovoMinimo)),
    fail.
    
%% PASSO INDUTTIVO
ric_prof((Corrente, Movibili), Soglia, Visitati, TempCammino, Cammino):-
    write(Corrente), write('Non ho sforato la Soglia\n'),
    \+checkVisitati((Corrente, Movibili), Visitati), %e' necessario perche' talvolta se riesegue due volte la stessa mossa ordina i movibili in maniera diversa quindi la member fallisce
                                                %nei visitati dobbiamo per forza tenere le coppie, gli stati sono diversi dalle posizioni (per via
                                                %della possibilita' di modificare il labirinto)
    applicabile(NuovaAzione, Corrente, Movibili, TempCammino),
    trasforma(NuovaAzione, Corrente, Movibili, NuovoStato, NuoviMovibili), %trasforma deve prima ordinare Movibili+Corrente a seconda di NuovaAzione, e poi spostarli uno ad uno tutti
                                                                           %al momento non e' garantito che il martello sia sempre in testa, bisogna decidere se modificare i predicati
    updateSoglia(Corrente, NuovoStato, Movibili, NuoviMovibili, Soglia, NuovaSoglia), %questo predicato e' necessario perche' abbiamo due casi diversi nel caso in cui abbiamo preso il martello o no
    ric_prof((NuovoStato, NuoviMovibili), NuovaSoglia, [(Corrente, Movibili) | Visitati], [NuovaAzione | TempCammino], Cammino).
