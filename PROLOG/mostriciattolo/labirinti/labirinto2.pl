num_righe(8).
num_colonne(8).

limite(1926).

iniziale(pos(8,8)).

occupata(pos(1,6)).
occupata(pos(2,2)).
occupata(pos(3,8)).
occupata(pos(4,3)).
occupata(pos(5,4)).
occupata(pos(6,1)).
occupata(pos(7,7)).
occupata(pos(8,3)).

finale(pos(5,3)).

gemma(pos(2,8)). % Chiusa dal ghiaccio
gemma(pos(3,3)).
gemma(pos(5,1)).

ghiaccio(pos(2,6)).
ghiaccio(pos(3,6)).
ghiaccio(pos(3,7)).
ghiaccio(pos(8,5)).

%% Ghiaccio per chiudere il finale e fare test
% ghiaccio(pos(5,2)).
% ghiaccio(pos(6,3)).

martello(pos(8,2)).

avversario(pos(1,5)).

movibili([martello(pos(8,2)), gemma(pos(2,8)), gemma(pos(3,3)), gemma(pos(5,1)), ghiaccio(pos(2,6)), ghiaccio(pos(3,6)), ghiaccio(pos(3,7)), ghiaccio(pos(8,5))]).
