num_righe(8).
num_colonne(8).

limite(1926).

iniziale(pos(7,8)).

occupata(pos(1,1)).
occupata(pos(2,5)).
occupata(pos(5,4)).
occupata(pos(6,5)).
occupata(pos(6,6)).
occupata(pos(6,8)).
occupata(pos(7,5)).
occupata(pos(8,1)).
occupata(pos(8,5)).
occupata(pos(8,6)).

finale(pos(3,2)).

gemma(pos(1,8)).
gemma(pos(5,5)).
gemma(pos(8,2)).

ghiaccio(pos(7,2)).
ghiaccio(pos(7,3)).
ghiaccio(pos(7,4)).

%% Ghiaccio per chiudere il finale e fare test
% ghiaccio(pos(2,2)).
% ghiaccio(pos(2,1)).
% ghiaccio(pos(3,3)).
% ghiaccio(pos(3,1)).

martello(pos(1,2)).

avversario(pos(8,7)).

movibili([martello(pos(1,2)), gemma(pos(1,8)), gemma(pos(5,5)), gemma(pos(8,2)), ghiaccio(pos(7,2)), ghiaccio(pos(7,3)), ghiaccio(pos(7,4))]).
