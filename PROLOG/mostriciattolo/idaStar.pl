:- ['utility'], 
['applicabile'], 
['sposta'], 
['trasforma'], 
['../visualizza'], 
['checkUscita'], 
['labirinti/mostriciattolo1'], 
%['labirinti/labirinto1'],
%['labirinti/labirinto2'],
%['labirinti/labirinto3'],
['scegliAzione'].

ricerca:-
    iniziale(S0),
    movibili(Movibili), %prenda la lista degli oggtti che possono cambiare posizione nel tempo (ghiaccio, gemme, avversario, martello)
    checkUscita, %Controlla che l' uscita sia libera. Se no, forzera' l' euristica ad andare prima sul martello (asserendo un predicato di controllo, valido sempre, che avra' come semantica "se non 

    Soglia is 1, %4 e' la soglia massima inseribile per garantire l' ottimalita' testando il labirinto del prof con uscita aperta
                  % aggiungendo ghiaccio(pos(4,7)), ghiaccio(pos(5,7)), ghiaccio(pos(5,8)), si blocca l' uscita e la soglia massima e' 14
    

    write('Soglia iniziale: '), write(Soglia), write('\n'),

    wrapperRicProf((S0, Movibili), Soglia, Cammino), 
    reverse(Cammino, Soluzione),
    write('\nIl risultato e' ), write(Soluzione), write('\n '), 
    write('La lunghezza e '), length(Cammino, Int), write(Int), write('\n ').



%%CASO BASE
wrapperRicProf((Corrente, Movibili), Soglia, Cammino):- ric_prof((Corrente, Movibili), Soglia, [], [], Cammino), !.

%%CASO DI FALLIMENTO, AGGIORNAMENTO DELLA SOGLIA
wrapperRicProf((Corrente, Movibili), Soglia, Cammino):-
    NuovaSoglia is Soglia+1,    
    
    write('\nNuova Soglia: '), write(NuovaSoglia),write('\n'),
    limite(Limite), 
    Limite > NuovaSoglia,!, %questo cut potenzialmente e' inutile

    wrapperRicProf((Corrente, Movibili), NuovaSoglia, Cammino).


%% CASO BASE
ric_prof((S, _), _, _, Cammino, Cammino):- finale(S),!.


ric_prof((Corrente, Movibili), Soglia, Visitati, TempCammino, Cammino):-
    Soglia>0,
    \+checkVisitati((Corrente, Movibili), Visitati), %e' necessario perche' talvolta se riesegue due volte la stessa mossa ordina i movibili in maniera diversa quindi la member fallisce
                                                %nei visitati dobbiamo per forza tenere le coppie, gli stati sono diversi dalle posizioni (per via
                                                %della possibilita' di modificare il labirinto)
    scegliAzione(Corrente, Movibili, TempCammino, NuovaAzione),
    trasforma(NuovaAzione, Corrente, Movibili, NuovoStato, NuoviMovibili), %trasforma deve prima ordinare Movibili+Corrente a seconda di NuovaAzione, e poi spostarli uno ad uno tutti
    NuovaSoglia is Soglia-1,
    ric_prof((NuovoStato, NuoviMovibili), NuovaSoglia, [(Corrente, Movibili) | Visitati], [NuovaAzione | TempCammino], Cammino).
