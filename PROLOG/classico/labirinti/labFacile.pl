num_righe(5).
num_colonne(5).

limite(Risultato) :- num_righe(NR), num_colonne(NC), Risultato is NR*NC.

/*pos(riga, colonna)*/

/*pos iniziale e pos finale.*/
iniziale(pos(4,2)).
finale(pos(50,1)).

occupata(pos(10,10)).
