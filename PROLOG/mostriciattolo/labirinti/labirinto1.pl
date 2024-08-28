num_righe(8).
num_colonne(8).

limite(1926).

iniziale(pos(5,4)).

occupata(pos(1,3)).
occupata(pos(2,6)).
occupata(pos(3,3)).
occupata(pos(3,4)).
occupata(pos(3,5)).
occupata(pos(3,6)).
occupata(pos(4,3)).
occupata(pos(5,3)).
occupata(pos(5,6)).
occupata(pos(6,3)).
occupata(pos(6,4)).
occupata(pos(6,5)).
occupata(pos(6,6)).
occupata(pos(7,1)).
occupata(pos(7,7)).
occupata(pos(8,5)).

finale(pos(5,2)).

gemma(pos(1,1)).
gemma(pos(3,7)).
gemma(pos(8,5)).

% NON C'É GHIACCIO
ghiaccio(pos(-1,-1)).
% NON C'É MARTELLO

avversario(pos(8,8)).

movibili([gemma(pos(1,1)), gemma(pos(3,7)), gemma(pos(8,5))]).

