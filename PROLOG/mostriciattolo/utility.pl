%Attenzione che non funziona piu' con piu' uscite
valutazione(StatoCorrente, Path, Movibili, Risultato):-
    distanza(StatoCorrente, Distanza, Movibili),
    length(Path, Lunghezza),
    Risultato is Lunghezza + Distanza.

manhattan(pos(R1, C1), pos(R2, C2), D):- D is abs(R2-R1) + abs(C2-C1).

%L' EURISTICA DEVE ESSERE SEMPRE MAGGIORE QUANDO IL MARTELLO NON E' PRESO
distanza(P1, Costo, [martello(P2)|_]):- %SUPPONE CHE IL MARTELLO SIA SEMPRE IN TESTA
    priorityMartello, %predicato che avro' asserito se l' uscita non e' libera, a questo punto fin tanto che c' e' il martello mi guidera' verso quest' ultimo
    manhattan(P1, P2, Costo1),!,
    limite(Costo2),
    Costo is Costo1 + Costo2.
    
distanza(P1, Costo, _):-
    finale(P2),
    manhattan(P1, P2, Costo).

ordina(sud, Lista, ListaOrdinata):-sort(1, @>=, Lista, ListaOrdinata).
ordina(nord, Lista, ListaOrdinata):-sort(1, @=<, Lista, ListaOrdinata).
ordina(est, Lista, ListaOrdinata):-sort(2, @>=, Lista, ListaOrdinata).
ordina(ovest, Lista, ListaOrdinata):-sort(2, @=<, Lista, ListaOrdinata).