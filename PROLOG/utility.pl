valutazione(StatoCorrente, Path, Risultato):- 
    distanzaMinima(StatoCorrente, Distanza),
    length(Path, Lunghezza),
    Risultato is Lunghezza + Distanza.


distanzaMinima(StatoCorrente, DistanzaMinima):-
    findall(Distanza, manhattan(StatoCorrente, Distanza), Distanze),
    min_list(Distanze, DistanzaMinima).
    
manhattan(pos(R1, C1), Costo):-
    finale(pos(R2,C2)),
    Costo is abs(R2-R1) + abs(C2-C1).

