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

aStar([Corrente, Path, Valutazione], Frontiera, Visitati, _):-
    findall(Azione, applicabile(Azione, Corrente), Azioni),
    checkVisitati(Visitati, Corrente, Azioni, NuoviVisitati),
    generaStati(Corrente, Path, Valutazione, Azioni, Frontiera, NuoviVisitati,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]), %Questo e' l' output
    aStar(TestaDellaNuovaFrontiera, CodaDellaNuovaFrontiera, NuoviVisitati, _).


checkVisitati(NuoviVisitati, _, [], NuoviVisitati).
checkVisitati(Visitati, Corrente, [Azione | CodaAzioni], _):-
    trasforma(Azione, Corrente, NuovoStato),
    \+member(NuovoStato, Visitati),
    checkVisitati([NuovoStato | Visitati], Corrente, CodaAzioni, _).

checkVisitati(Visitati, Corrente, [ _ | CodaAzioni], _):-
    checkVisitati(Visitati, Corrente, CodaAzioni, _), !.


generaStati(Corrente, Path, Valutazione, Azioni, Frontiera, Visitati, _):-
    

