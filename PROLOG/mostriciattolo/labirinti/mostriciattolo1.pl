num_righe(8).
num_colonne(8).

limite(1926).

iniziale(pos(1,4)).

occupata(pos(2,2)).
occupata(pos(1,6)).
occupata(pos(2,8)).
occupata(pos(3,8)).
occupata(pos(4,4)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,2)).
occupata(pos(7,2)).
occupata(pos(7,6)).
occupata(pos(8,3)).

finale(pos(4,8)).


gemma(pos(1,7)).
gemma(pos(5,4)).
gemma(pos(8,8)).

ghiaccio(pos(2,6)).
ghiaccio(pos(2,7)).
ghiaccio(pos(7,7)).

%aggiunti, chiudono l' uscita
ghiaccio(pos(4,7)).
ghiaccio(pos(5,7)).
ghiaccio(pos(5,8)).

martello(pos(8,2)).

avversario(pos(7,4)).

movibili([martello(pos(8,2)), gemma(pos(1,7)), gemma(pos(5,4)),gemma(pos(8,8)), ghiaccio(pos(2,6)), ghiaccio(pos(2,7)), ghiaccio(pos(4,7)), ghiaccio(pos(5,7)), ghiaccio(pos(5,8)),  ghiaccio(pos(7,7)), avversario(pos(7,4))]).


