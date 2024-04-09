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
    checkVisitati(Visitati, Corrente, Azioni, [], NuoviStati), %NuoviStati sono i nuovi stati generati, visitati ora e' di input output e viene aggiornata
    generaStati(Corrente, Path, Valutazione, NuoviStati, Frontiera,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]), %Questo e' l' output
    aStar(TestaDellaNuovaFrontiera, CodaDellaNuovaFrontiera, Visitati, _).


checkVisitati(_, _, [], NuoviStati, NuoviStati).

checkVisitati(Visitati, Corrente, [Azione | CodaAzioni], NuoviStati, _):-
    trasforma(Azione, Corrente, NuovoStato),
    \+member(NuovoStato, Visitati),
    checkVisitati([NuovoStato | Visitati], Corrente, CodaAzioni, [NuovoStato | NuoviStati], _).

checkVisitati(Visitati, Corrente, [ _ | CodaAzioni], NuoviStati, _):-
    checkVisitati(Visitati, Corrente, CodaAzioni, NuoviStati, _), !.

%genera stati in realta' deve solo aggiungere i nuovi stati alla frontiera
generaStati(Corrente, Path, Valutazione, NuoviStati, Frontiera,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]).

