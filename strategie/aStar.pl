:- ['../labirinti/labirintoProf'], ['../utility'], ['../azioni'].

algoritmoAStar:-
    iniziale(Start),
    valutazione(Start, [], Valutazione),
    aStar([Start, [], Valutazione], [], [Start], ReversedRis),
    reverse(ReversedRis, Risultato),
    write('\nIl risultato \' e '), write(Risultato), !. %con il cat qui restituisce solo il primo risultato


%% CASO BASE - TERMINAZIONE
aStar([Corrente, Path, _], _, _, Path):-
    finale(Corrente).

aStar([Corrente, Path, Valutazione], Frontiera, Visitati, _):-
    findall(Azione, applicabile(Azione, Corrente), Azioni),
    checkVisitati(Visitati, Corrente, Azioni, [], NuoviStati), %NuoviStati sono i nuovi stati generati, visitati ora e' di input output e viene aggiornata
    
    write('\n Nuovi Stati: '), write(NuoviStati),

    generaStati(Corrente, Path, Valutazione, NuoviStati, Frontiera,
         [TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]), %Questo e' l' output
    write('\nNuova Frontiera: '), write([TestaDellaNuovaFrontiera | CodaDellaNuovaFrontiera]),
%    aStar(TestaDellaNuovaFrontiera, CodaDellaNuovaFrontiera, Visitati, _).



checkVisitati(_, _, [], NuoviStati, NuoviStati). %nuovi stati contiene coppie (posizione,azione)

checkVisitati(Visitati, Corrente, [Azione | CodaAzioni], NuoviStati, Risultato):-
    trasforma(Azione, Corrente, NuovoStato),
    \+member(NuovoStato, Visitati),!,
    checkVisitati([NuovoStato | Visitati], Corrente, CodaAzioni, [[NuovoStato, Azione] | NuoviStati], Risultato).

checkVisitati(Visitati, Corrente, [ _ | CodaAzioni], NuoviStati, Risultato):-
    checkVisitati(Visitati, Corrente, CodaAzioni, NuoviStati, Risultato).





%genera stati in realta' deve solo aggiungere i nuovi stati alla frontiera

%caso base
generaStati(_, _, _, [], NuovaFrontiera, NuovaFrontiera). %se ho finito i nuovi sttai da inserire, sono nel caso base

%caso ricorsivo
%forse non ha bisogno ne di Corrente ne di Valutazione
%azione serve solo per concatenare il path quanto si inserisce il nuovo stato nella frontiera
%forse nuova frontiera e' inutile si puo' usare Frontiera come in/out
generaStati(Corrente, Path, Valutazione, [[NuovoStato, Azione] | CodaNuoviStati], Frontiera, NuovaFrontiera):-
    valutazione(NuovoStato, Path, NuovaValutazione),
    inserimentoOrdinato(NuovoStato, [Azione|Path], NuovaValutazione, Frontiera, NuovaFrontiera),
    generaStati(Corrente, Path, Valutazione, CodaNuoviStati, Frontiera, NuovaFrontiera).

inserimentoOrdinato(NuovoStato, Path, Valutazione, Frontiera, NuovaFrontiera):-
    append([NuovoStato, Path, Valutazione], Frontiera, NuovaFrontiera). %prova non ordinata
