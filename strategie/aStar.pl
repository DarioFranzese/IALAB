:- ['../labirinti/labirintoProf'], ['../utility'], ['../azioni'].

algoritmoAStar:-
    iniziale(Start),
    valutazione(Start, [], Valutazione),
    aStar([Start, [], Valutazione], [], [Start], ReversedRis),
    reverse(ReversedRis, Risultato),
    write(Risultato).

%% CASO BASE - TERMINAZIONE
aStar([Corrente, Path, _], _, _, Path):-
    finale(Corrente), !.

aStar([Corrente, Path, Valutazione], Frontiera, Visitati, Risultato):-
    findall(Azione, applicabile(Azione, Corrente), Azioni),
    checkVisitati(Visitati, Corrente, Azioni, NuoviVisitati),
    generaStati(Corrente, Path, Azioni, Frontiera, NuoviVisitati,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]),
    aStar(TestaDellaNuovaFrontiera, CodaDellaNuovaFrontiera, _, _).

checkVisitati(NuoviVisitati, _, [], NuoviVisitati):- write(NuoviVisitati).
checkVisitati(Visitati, Corrente, [Azione | CodaAzioni], NuoviVisitati):-
    trasforma(Azione, Corrente, NuovoStato),
    \+member(NuovoStato, Visitati),!,
    checkVisitati([NuovoStato | Visitati], Corrente, CodaAzioni, NuoviVisitati).

checkVisitati(Visitati, Corrente, [ _ | CodaAzioni], _):-
    checkVisitati(Visitati, Corrente, CodaAzioni, _).


%generaStati(Corrente, Path, Azioni, Frontiera, Visitati, ):-

