
%caso migliore, ho sia lo stesso stato corrente che gli stessi movibili visitati, posso evitare la member uno ad uno (checkMovibiliVisitati)
checkVisitati((Corrente, Movibili), [(Corrente, Movibili) | _]).

%lo stato e' lo stesso, controllo i movibili
checkVisitati((Corrente, Movibili), [(Corrente, MovibiliVisitati) | _]):-
    length(Movibili, L),
    length(MovibiliVisitati, L),
    checkVisitatiMovibili(Movibili, MovibiliVisitati), !. %la seconda variabile non viene mai toccata

%lo stato e' diverso, continuo a controllare gli altri Visitati
checkVisitati((Corrente, Movibili), [_ | CodaVisitati]):-
    checkVisitati((Corrente, Movibili), CodaVisitati), !.

%l' elemento che stavo scorrendo non e' stato trovato tra i movibili, c' e' almeno un movibile diverso
checkVisitatiMovibili([], _). 

%ho trovato una corrispondenza per l' elemento attuale (Testa) quindi passo al prossimo elemento e "resetto" la lista di scorrimento (terza variabile)
checkVisitatiMovibili([Testa | Coda], MovibiliVisitati):-
    member(Testa, MovibiliVisitati),
    checkVisitatiMovibili(Coda, MovibiliVisitati), !.

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

ordina(sud, Lista, ListaOrdinata):-sort(1, @>=, Lista, ListaOrdinata).
ordina(nord, Lista, ListaOrdinata):-sort(1, @=<, Lista, ListaOrdinata).
ordina(est, Lista, ListaOrdinata):-sort_on_second_desc( Lista, ListaOrdinata).
ordina(ovest, Lista, ListaOrdinata):-sort_on_second_asc( Lista, ListaOrdinata).