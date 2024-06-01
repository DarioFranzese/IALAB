%CHECK AVVERSARIO SI OCCUPA DI CONTROLLARE CHE SE C' E' UN AVVERSARIO SULLA TRAIETTORIA QUESTO SIA COPERTO DA QUALCHE OSTACOLO.
%SUCCESSIVAMENTE CONTROLLA CHE NELL' EFFETTUARE L' AZIONE, L' AVVERSARIO NON GLI FINISCA ADDOSSO
%CIO' VIENE FATTO ANDANDO A CONTROLLARE UNA POSIZIONE ALLA VOLTA

%MI FERMO PERCHE' HO FINITO IL LABIRINTO
checkAvversario(nord, 1, _, _).
checkAvversario(ovest, _, 1, _).
checkAvversario(est, _, C, _):- num_righe(C).
checkAvversario(sud, R, _, _):- num_colonne(R).

%MI FERMO PERCHE' HO TROVATO PRIMA UN OSTACOLO CHE L' AVVERSARIO
checkAvversario(_, R, C, _):- occupata(pos(R,C)).
checkAvversario(_, R, C, Movibili):- member(gemma(pos(R,C)), Movibili).
checkAvversario(_, R, C, _):- finale(pos(R, C)).
checkAvversario(_, R, C, [martello(pos(_, _)) | Movibili ]):- member(ghiaccio(pos(R,C)), Movibili). %E' UN CASO BLOCCANTE SOLO SE NON HO IL MARTELLO.

%CASO SPECIALE QUANDO CONTROLLO CHE L' AVVERSARIO NON MI FINISCA ADDOSSO: IL MARTELLO FUNGE DA OSTACOLO ALL' AVVERSARIO
checkAvversario(_, R, C, [martello(pos(-1,-1)) | Movibili]):- member(martello(pos(R,C)), Movibili). 

%CASO IN CUI "PRENDEREI" IL MARTELLO, RICHIAMA SE STESSO SIMULANDO LA PRESA DEL MARTELLO (toglierlo dai movibili)
%questo dopo andra' sicuramente avanti ma avrei dovuto fare 4 predicati diversi a seconda dell' azione, preferisco fargli perdere tempo anziche' mettermi a scriverle io
checkAvversario(Azione, R, C, [martello(pos(R, C)) | CodaMovibili]):- !, checkAvversario(Azione, R, C, CodaMovibili).

%CHIAMATE RICORSIVE PER PROSEGUIRE LA RICERCA
checkAvversario(nord, R, C, Movibili):- NR is R-1, \+member(avversario(pos(NR, C)), Movibili), !, checkAvversario(nord, NR, C, Movibili).
checkAvversario(sud, R, C, Movibili):-  NR is R+1, \+member(avversario(pos(NR, C)), Movibili), !, checkAvversario(sud, NR, C, Movibili).
checkAvversario(est, R, C, Movibili):-  NC is C+1, \+member(avversario(pos(R, NC)), Movibili), !, checkAvversario(est, R, NC, Movibili).
checkAvversario(ovest, R, C, Movibili):- NC is C-1, \+member(avversario(pos(R, NC)), Movibili), !, checkAvversario(ovest, R, NC, Movibili).



%Daro' per scontato che il martello e' sempre il primo elemento della lista dei movibili, se questo non dovesse accadere vanno cambiati i due predicati che anziche' usare Movibili usano la lista esplicita
%con il martello in testa
applicabile(nord, pos(R, C), Movibili):-
    checkAvversario(nord, R, C, Movibili),!, %prima controllo che non ci sia sulla traiettoria
    checkAvversario(sud, R, C, [martello(pos(-1,-1)) | Movibili]),!. %poi controllo che "non mi venga addosso"
                                                                   %l' inserire martello(pos(-1, -1)) in testa e' un trucchetto per distinguere le due chiamate qui. In particolare questo' fara' attivare
                                                                   %il predicato per il quale se trovo un martello mi fermo (e di conseguenza non si attivera' mai quello che simula la presa del martello)
applicabile(sud, pos(R, C), Movibili):-
    checkAvversario(sud, R, C, Movibili),!,
    checkAvversario(nord, R, C, [martello(pos(-1,-1)) | Movibili]),!.

applicabile(est, pos(R, C), Movibili):-
    checkAvversario(est, R, C, Movibili),!,
    checkAvversario(ovest, R, C, [martello(pos(-1,-1)) | Movibili]),!.

applicabile(ovest, pos(R, C), Movibili):-
    checkAvversario(ovest, R, C, Movibili),!,
    checkAvversario(est, R, C, [martello(pos(-1,-1)) | Movibili]),!.