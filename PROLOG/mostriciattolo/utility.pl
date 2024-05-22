valutazione(StatoCorrente, Path, Risultato):- 
    distanzaMinima(StatoCorrente, Distanza),
    length(Path, Lunghezza),
    Risultato is Lunghezza + Distanza.


distanzaMinima(StatoCorrente, DistanzaMinima):-
    findall(Distanza, manhattan(StatoCorrente, Distanza), Distanze),
    min_list(Distanze, DistanzaMinima).
    
%SE L' USCITA E' CHIUSA HO ASSERITO my_martello, QUESTA COSA E' PROBABILMENTE DA RIVEDERE PERCHE' IO DEVO A PRESCINDERE ASSERIRE my_martello ALTRIMENTI
%NON POSSO GESTIRE IL MOVIMENTO NEL LABIRINTO. PROBABILMENTE BASTA SOLO AGGIUNGERE UN ALTRO PREDICATO DI CONTROLLO NELLA KB CHE FUNGE DA FLAG IN PRATICA
%E PERMETTE DI ATTIVARE O MENO QUESTA REGOLA (potrebbe essere tipo priority_martello(1) o na roba simile) PER CAPIRE DOVE DIRIGERE L' AGENTE
manhattan(pos(R1, C1), Costo):-
    my_martello(pos(R2,C2)),
    Costo is abs(R2-R1) + abs(C2-C1).
    
manhattan(pos(R1, C1), Costo):-
    finale(pos(R2,C2)),
    Costo is abs(R2-R1) + abs(C2-C1).

