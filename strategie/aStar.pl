:- ['../labirinti/labirintoProf'], ['../utility'].

algoritmoAStar:-
    iniziale(Start),
    distanzaMinima(Start, Ris),
    write(Ris).
