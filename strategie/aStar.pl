:- ['../labirinti/hard15x15'], ['../utility'], ['../azioni'], ['../visualizza'].

algoritmoAStar:-
    iniziale(Start),
    valutazione(Start, [], Valutazione),
    aStar([Start, [], Valutazione], [], [Start], ReversedRis),
    reverse(ReversedRis, Risultato),
    write('\nIl risultato \' e '), write(Risultato), !,
    length(Risultato, Lung), write("\nLunghezza Percorso: "), write(length(Lung)). %con il cat qui restituisce solo il primo risultato


%% CASO BASE - TERMINAZIONE
aStar([Corrente, Path, _], _, _, Path):-
    finale(Corrente), !.

aStar([Corrente, Path, Valutazione], Frontiera, Visitati, Risultato):-
    findall(Azione, applicabile(Azione, Corrente), Azioni),
    checkVisitati(Visitati, Corrente, Azioni, [], NuoviStati, NuoviVisitati), %NuoviStati sono i nuovi stati generati, visitati ora e' di input output e viene aggiornata

    generaStati(Corrente, Path, Valutazione, NuoviStati, Frontiera,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]), %Questo e' l' output
    
    aStar(TestaDellaNuovaFrontiera, CodaDellaNuovaFrontiera, NuoviVisitati, Risultato).



checkVisitati(Visitati, _, [], NuoviStati, NuoviStati, Visitati). %nuovi stati contiene coppie (posizione,azione)

checkVisitati(Visitati, Corrente, [Azione | CodaAzioni], NuoviStati, Risultato, NuoviVisitati):-
    trasforma(Azione, Corrente, NuovoStato),
    \+member(NuovoStato, Visitati),!,
    checkVisitati([NuovoStato | Visitati], Corrente, CodaAzioni, [[NuovoStato, Azione] | NuoviStati], Risultato, NuoviVisitati).

checkVisitati(Visitati, Corrente, [ _ | CodaAzioni], NuoviStati, Risultato, NuoviVisitati):-
    checkVisitati(Visitati, Corrente, CodaAzioni, NuoviStati, Risultato, NuoviVisitati).


%caso base
generaStati(_, _, _, [], NuovaFrontiera, NuovaFrontiera). %se ho finito i nuovi sttai da inserire, sono nel caso base

%caso ricorsivo
generaStati(Corrente, Path, Valutazione, [[NuovoStato, Azione] | CodaNuoviStati], Frontiera, NuovaFrontiera):-
    valutazione(NuovoStato, Path, NuovaValutazione),
    inserimentoOrdinato(NuovoStato, [Azione|Path], NuovaValutazione, Frontiera, Risultato),
    generaStati(Corrente, Path, Valutazione, CodaNuoviStati, Risultato, NuovaFrontiera).

%caso base in cui Valutazione e' il valore Massimo della lista
inserimentoOrdinato(NuovoStato, Path, Valutazione, [], [[NuovoStato, Path, Valutazione]]):-!.

inserimentoOrdinato(NuovoStato, Path, Valutazione, [[TestaStato, TestaPath, Val] | CodaFrontiera], [[NuovoStato, Path, Valutazione], [TestaStato, TestaPath, Val] | CodaFrontiera]):-
%   append([[NuovoStato, Path, Valutazione]], Frontiera, NuovaFrontiera). %prova non ordinata
    Valutazione =< Val.

%inserimento ordinato in lista ordinata di interi esempio
inserimentoOrdinato(NuovoStato, Path, Valutazione, [[TestaStato, TestaPath, Val] | CodaFrontiera], [[TestaStato, TestaPath, Val] | NuovaFrontiera]):-
    Valutazione > Val,!,
    inserimentoOrdinato(NuovoStato, Path, Valutazione, CodaFrontiera, NuovaFrontiera).
    


