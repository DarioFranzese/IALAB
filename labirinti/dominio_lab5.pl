/*Dominio del labirinto*/
num_righe(20).
num_colonne(20).

/*pos(riga, colonna)*/

/*pos iniziale e pos finale.*/
iniziale(pos(4,2)).
finale(pos(18,15)).
finale(pos(18,12)). %aggiunto, testao funziona

/*wall*/
%occupata(pos(1,5)). %aggiunto, blocca l' uscita, funziona
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(7,5)).
occupata(pos(6,5)).
occupata(pos(5,5)).
occupata(pos(4,5)).
occupata(pos(3,5)).
occupata(pos(2,5)).

occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).
occupata(pos(5,7)).
occupata(pos(6,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).

occupata(pos(5,13)).
occupata(pos(6,13)).
occupata(pos(7,13)).
occupata(pos(8,13)).
occupata(pos(9,13)).
occupata(pos(10,13)).
occupata(pos(11,13)).
occupata(pos(12,13)).
occupata(pos(13,13)).
occupata(pos(14,13)).
occupata(pos(15,13)).
occupata(pos(16,13)).
occupata(pos(17,13)).
occupata(pos(18,13)).
occupata(pos(19,13)).
occupata(pos(20,13)).

occupata(pos(17,1)).
occupata(pos(17,2)).
occupata(pos(17,3)).
occupata(pos(17,4)).
occupata(pos(17,5)).