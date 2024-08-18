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
    limite(Costo2), %L' euristica valutata senza martello (ma dovendolo prendere per forza) deve essere sempre maggiore di quando
                    %il martello non e' strettamente necessario (non c' e' priorityMartello) o e' stato gia' preso
    Costo is Costo1 + Costo2.
    
distanza(P1, Costo, _):-
    finale(P2),
    manhattan(P1, P2, Costo).


%get_column_asc/desc e sort_on_second_asc/desc sono predicati ausiliari che servono per ordinare le liste di movibili in base alla colonna perche'
%il predicato sort/4 riconosce pos(X,Y) come un unico argomento (giustamente) e quindi ho dovuto trovare un escamotage

get_column_asc( avversario(pos(_,Y)), Y).
get_column_asc( corrente(pos(_,Y)), Y).
get_column_asc( martello(pos(_,Y)), Y).
get_column_asc( ghiaccio(pos(_,Y)), Y).
get_column_asc( gemma(pos(_,Y)), Y).

sort_on_second_asc(L, SortedL) :-
    map_list_to_pairs(get_column_asc, L, Pairs),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, SortedL).

get_column_desc( avversario(pos(_,Y)), R):- R is -Y.
get_column_desc( corrente(pos(_,Y)), R):- R is -Y.
get_column_desc( martello(pos(_,Y)), R):- R is -Y.
get_column_desc( ghiaccio(pos(_,Y)), R):- R is -Y.
get_column_desc( gemma(pos(_,Y)), R):- R is -Y.

sort_on_second_desc(L, SortedL) :-
    map_list_to_pairs(get_column_desc, L, Pairs),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, SortedL).

ordina(sud, Lista, ListaOrdinata):-sort(Lista, ListaOrdinata).
ordina(nord, Lista, ListaOrdinata):-sort(Lista, ListaOrdinata).
ordina(est, Lista, ListaOrdinata):-sort_on_second_desc( Lista, ListaOrdinata).
ordina(ovest, Lista, ListaOrdinata):-sort_on_second_asc( Lista, ListaOrdinata).