%CHECK AVVERSARIO SI OCCUPA DI CONTROLLARE CHE SE C' E' UN AVVERSARIO SULLA TRAIETTORIA QUESTO SIA COPERTO DA QUALCHE OSTACOLO.
%SUCCESSIVAMENTE CONTROLLA CHE NELL' EFFETTUARE L' AZIONE, L' AVVERSARIO NON GLI FINISCA ADDOSSO
%CIO' VIENE FATTO ANDANDO A CONTROLLARE UNA POSIZIONE ALLA VOLTA

%implementati predicati di movimento effettivi, si potrebbe sfruttare quelli per check avversario:basta chiamarlo nelle due direzioni (input e speculare)
%e verificare che la posizione del corrente e dell' avversario non siano uguali (ovvero l' avversario e' finito addosso al player o viceversa)

/***********************************************************************/
%per facilitare il debug disattivo checkAvversario, per non riscrivere tutti i predicati faccio questo fantoccio che poi VA TOLTO!
checkAvversario(_, _, _, _).
/*************************************************************************/

%MI FERMO PERCHE' HO FINITO IL LABIRINTO
checkAvversario(nord, 1, _, _).
checkAvversario(ovest, _, 1, _).
checkAvversario(est, _, C, _):- num_colonne(C).
checkAvversario(sud, R, _, _):- num_righe(R).

%MI FERMO PERCHE' HO TROVATO PRIMA UN OSTACOLO CHE L' AVVERSARIO
checkAvversario(_, R, C, _):- occupata(pos(R,C)), !.
checkAvversario(_, R, C, Movibili):- member(gemma(pos(R,C)), Movibili), !.
checkAvversario(_, R, C, _):- finale(pos(R, C)), !.
checkAvversario(_, R, C, [martello(pos(_, _)) | Movibili ]):- member(ghiaccio(pos(R,C)), Movibili), !. %E' UN CASO BLOCCANTE SOLO SE NON HO IL MARTELLO.

%CASO SPECIALE QUANDO CONTROLLO CHE L' AVVERSARIO NON MI FINISCA ADDOSSO: IL MARTELLO FUNGE DA OSTACOLO ALL' AVVERSARIO
checkAvversario(_, R, C, [martello(pos(-1,-1)) | Movibili]):- member(martello(pos(R,C)), Movibili), !. 

%CASO IN CUI "PRENDEREI" IL MARTELLO, RICHIAMA SE STESSO SIMULANDO LA PRESA DEL MARTELLO (toglierlo dai movibili)
%questo dopo andra' sicuramente avanti ma avrei dovuto fare 4 predicati diversi a seconda dell' azione, preferisco fargli perdere tempo anziche' mettermi a scriverle io
checkAvversario(Azione, R, C, [martello(pos(R, C)) | CodaMovibili]):- checkAvversario(Azione, R, C, CodaMovibili), !.

%CHIAMATE RICORSIVE PER PROSEGUIRE LA RICERCA
checkAvversario(nord, R, C, Movibili):- NR is R-1, \+member(avversario(pos(NR, C)), Movibili), checkAvversario(nord, NR, C, Movibili), !.
checkAvversario(sud, R, C, Movibili):-  NR is R+1, \+member(avversario(pos(NR, C)), Movibili), checkAvversario(sud, NR, C, Movibili), !.
checkAvversario(est, R, C, Movibili):-  NC is C+1, \+member(avversario(pos(R, NC)), Movibili), checkAvversario(est, R, NC, Movibili), !.
checkAvversario(ovest, R, C, Movibili):- NC is C-1, \+member(avversario(pos(R, NC)), Movibili), checkAvversario(ovest, R, NC, Movibili), !.



%Daro' per scontato che il martello e' sempre il primo elemento della lista dei movibili, se questo non dovesse accadere vanno cambiati i due predicati che anziche' usare Movibili usano la lista esplicita
%con il martello in testa
%Ha senso muovere la scacchiera anche se non si muove il corrente, non ha senso fare due volte la stessa mossa (da li il primo controllo)
%con la lista vuota si rompe, quindi ho trovato questo escamotage
applicabile(Azione, Posizione, Movibli, []):- applicabile(Azione, Posizione, Movibli, [-1]), !.

applicabile(nord, pos(R, C), Movibili, [UltimaAzione | _]):-
    nord \= UltimaAzione,
    checkAvversario(nord, R, C, Movibili), %prima controllo che non ci sia sulla traiettoria
    checkAvversario(sud, R, C, [martello(pos(-1,-1)) | Movibili]). %poi controllo che "non mi venga addosso"
                                                                   %l' inserire martello(pos(-1, -1)) in testa e' un trucchetto per distinguere le due chiamate qui. In particolare questo' fara' attivare
                                                                   %il predicato per il quale se trovo un martello mi fermo (e di conseguenza non si attivera' mai quello che simula la presa del martello)
applicabile(est, pos(R, C), Movibili, [UltimaAzione | _]):-
    est \= UltimaAzione,
    checkAvversario(est, R, C, Movibili),
    checkAvversario(ovest, R, C, [martello(pos(-1,-1)) | Movibili]).

applicabile(sud, pos(R, C), Movibili, [UltimaAzione | _]):-
    sud \= UltimaAzione,
    checkAvversario(sud, R, C, Movibili),
    checkAvversario(nord, R, C, [martello(pos(-1,-1)) | Movibili]).

applicabile(ovest, pos(R, C), Movibili, [UltimaAzione | _]):-
    ovest \= UltimaAzione,
    checkAvversario(ovest, R, C, Movibili),
    checkAvversario(est, R, C, [martello(pos(-1,-1)) | Movibili]).