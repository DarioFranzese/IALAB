% Predicato per generare la visualizzazione del labirinto
visualizza_labirinto :-
    num_righe(NR),
    num_colonne(NC),
    iniziale(pos(XI, YI)),
    finale(pos(XF, YF)),
    visualizza_righe(NR, NC, 1, 1, XI, YI, XF, YF).

% Predicato per la visualizzazione delle righe del labirinto
visualizza_righe(0, _, _, _, _, _, _, _) :- !.
visualizza_righe(NR, NC, X, Y, XI, YI, XF, YF) :-
    NR > 0,
    visualizza_colonne(NC, X, Y, XI, YI, XF, YF),
    nl,
    NR1 is NR - 1,
    X1 is X + 1,
    visualizza_righe(NR1, NC, X1, 1, XI, YI, XF, YF).

% Predicato per la visualizzazione delle colonne del labirinto
visualizza_colonne(0, _, _, _, _, _, _) :- !.
visualizza_colonne(NC, X, Y, XI, YI, XF, YF) :-
    NC > 0,
    (   (X = XI, Y = YI) ->
        write('I') % Stampa l'inizio del labirinto
    ;   (X = XF, Y = YF) ->
        write('F') % Stampa la fine del labirinto
    ;   occupata(pos(X, Y)) ->
        write('#') % Stampa un ostacolo
    ;   write('.') % Stampa uno spazio libero
    ),
    write(' '), % Aggiunge uno spazio tra i simboli
    NC1 is NC - 1,
    Y1 is Y + 1,
    visualizza_colonne(NC1, X, Y1, XI, YI, XF, YF).



