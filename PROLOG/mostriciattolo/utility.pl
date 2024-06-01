%Attenzione che non funziona piu' con piu' uscite
valutazione(StatoCorrente, Path, Risultato):- 
    distanza(StatoCorrente, Distanza),
    length(Path, Lunghezza),
    Risultato is Lunghezza + Distanza.

manhattan(pos(R1, C1), pos(R2, C2), D):- D is abs(R2-R1) + abs(C2-C1).

distanza(P1, Costo):-
    priority_martello(1), %predicato che avro' asserito se l' uscita non e' libera, a questo punto fin tanto che c' e' il martello mi guidera' verso quest' ultimo
    martello(P2),
    manhattan(P1, P2, Costo).
    
distanza(P1, Costo):-
    finale(P2),
    manhattan(P1, P2, Costo).

ordina(sud, Lista, ListaOrdinata):-sort(1, @>=, Lista, ListaOrdinata).
ordina(nord, Lista, ListaOrdinata):-sort(1, @=<, Lista, ListaOrdinata).
ordina(est, Lista, ListaOrdinata):-sort(2, @>=, Lista, ListaOrdinata).
ordina(ovest, Lista, ListaOrdinata):-sort(2, @=<, Lista, ListaOrdinata).