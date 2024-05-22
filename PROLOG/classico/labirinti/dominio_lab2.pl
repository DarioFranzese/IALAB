/*Dominio del labirinto*/
num_righe(20).
num_colonne(8).

/*pos(riga, colonna)*/

/*pos iniziale e pos finale.*/
iniziale(pos(9,4)).
finale(pos(1,3)).
finale(pos(1,8)).

/*wall*/
occupata(pos(1,4)). %aggiunto, blocca finale(1,3)
occupata(pos(2,1)).
occupata(pos(2,2)).
occupata(pos(2,3)).
occupata(pos(2,4)).
occupata(pos(2,6)).

occupata(pos(3,4)).

occupata(pos(5,2)).
occupata(pos(5,3)).
occupata(pos(5,4)).
occupata(pos(5,5)).
occupata(pos(5,6)).
occupata(pos(5,7)).
occupata(pos(5,8)).

occupata(pos(6,2)).

occupata(pos(7,2)).
occupata(pos(7,4)).
occupata(pos(7,5)).
occupata(pos(7,6)).

occupata(pos(8,2)).
occupata(pos(8,6)).

occupata(pos(9,2)).
occupata(pos(9,6)).

occupata(pos(10,2)).
occupata(pos(10,6)).

occupata(pos(11,2)).
occupata(pos(11,3)).
occupata(pos(11,4)).
occupata(pos(11,5)).
occupata(pos(11,6)).

occupata(pos(12,2)).

occupata(pos(13,2)).
occupata(pos(13,6)).

occupata(pos(14,2)).
occupata(pos(14,6)).

occupata(pos(15,2)).
occupata(pos(15,4)).
occupata(pos(15,6)).

occupata(pos(16,2)).
occupata(pos(16,4)).
occupata(pos(16,6)).

occupata(pos(17,4)).
occupata(pos(17,6)).

occupata(pos(18,6)).

occupata(pos(19,6)).

occupata(pos(20,6)).