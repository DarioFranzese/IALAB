;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import GAME ?ALL) (export ?ALL))

(defrule human-player 
  (status (step ?s) (mode human))
  =>
  (printout t "Your guess at step " ?s crlf)
  (bind $?input (readline))
  (assert (guess (step ?s) (g  (explode$ $?input)) ))
  (pop-focus)
 )

(deftemplate colori-testati
  (multislot presenti (allowed-values blue green red yellow orange white black purple) (cardinality 0 4))
  (multislot assenti (allowed-values blue green red yellow orange white black purple) (cardinality 0 4))
)

(deftemplate coppia ;coppia che salvo nel cason in cui nei primi 5 step non ho trovato tutti i colori presenti
  (slot id (type INTEGER))
  (multislot colori (allowed-values blue green red yellow orange white black purple) (cardinality 2 2))
)

(deftemplate coppie-counter ;counter di quante coppie ci sono
  (slot counter (type INTEGER))
)

(deftemplate possibili-posizioni ;utilizzato per la fase di ordinamento
  (slot colore (allowed-values blue green red yellow orange white black purple))
  (multislot posizioni (allowed-values 1 2 3 4))
)

(deftemplate fase ;la strategia si suddivide in due fasi:ricerca dei colori e ordinamento di questi
  (slot nome (allowed-values ricerca ordinamento))
)

;;SALIENCE: L' ordine delle operazioni (di ricerca) e': POSIZIONI -> PRESENTI -> NUOVO GUESS
;;REGOLE DI ORDINAMENTO
(defrule crea-guess (declare (salience 10))
  (status (step ?s) (mode computer))
  (fase (nome ordinamento))

  (colori-testati (presenti $?presenti))
  (possibili-posizioni (colore ?c1) (posizioni 1 $?))
  (possibili-posizioni (colore ?c2) (posizioni $? 2 $?))
  (possibili-posizioni (colore ?c3) (posizioni $? 3 $?))
  (possibili-posizioni (colore ?c4) (posizioni $? 4))

  (test(member$ ?c1 $?presenti))
  (test(member$ ?c2 $?presenti))
  (test(member$ ?c3 $?presenti))
  (test(member$ ?c4 $?presenti))

  (test (neq ?c2 ?c1))
  (test (neq ?c2 ?c3))
  (test (neq ?c2 ?c4))

  (test (neq ?c3 ?c1))
  (test (neq ?c3 ?c4))

  (test (neq ?c4 ?c1))
  (not (guess (g ?c1 ?c2 ?c3 ?c4)))
=>
  (assert (guess (step ?s) (g ?c1 ?c2 ?c3 ?c4)))
  (printout t  "(" ?s ") Il codice e' : " ?c1 " " ?c2 " " ?c3 " " ?c4 crlf)
  (pop-focus)
)

;;REGOLE DI AGGIORNAMENTO DELLE POSIZIONI

(defrule aggiorna-posizioni-1 (declare (salience 6)) ;la salience serve sia per ricerca che per ordinamento
                                                     ;quando un colore "presente" raggiunge una sola posizione, rimuovila dagli altri "presenti" (uno alla volta)
  (fase (nome ricerca))
  (colori-testati (presenti $? ?c1 $?)) 
  (colori-testati (presenti $? ?c2 $?)) 
  (test (neq ?c2 ?c1))

  (possibili-posizioni (colore ?c1) (posizioni ?p1))
  ?pp <- (possibili-posizioni (colore ?c2) (posizioni $?prima ?p1 $?dopo))

=>
  (modify ?pp (posizioni $?prima $?dopo)) 
);questa regola si attivera' piu' volte anche in fase di ordinamento, e' molto potente

(defrule aggiorna-posizioni-rp (declare (salience 10));in questo caso abbiamo trovato solo rightplaced
                                                      ;questa regola si attiva anche in ordinamento, andra' in quel caso ad aggiornare
                                                      ;in maniera "errata" i colori assenti ma non ci interessa
  (fase (nome ricerca))
  (status (step ?s) (mode computer))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed 0))
  (test(> ?rp 0))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto))
  ?fatto1 <- (possibili-posizioni (colore ?primo)) 
  ?fatto2 <- (possibili-posizioni (colore ?secondo))
  ?fatto3 <- (possibili-posizioni (colore ?terzo))
  ?fatto4 <- (possibili-posizioni (colore ?quarto))

=>
  (modify ?fatto1 (posizioni 1))
  (modify ?fatto2 (posizioni 2))
  (modify ?fatto3 (posizioni 3))
  (modify ?fatto4 (posizioni 4))
)

(defrule aggiorna-posizioni-mp (declare (salience 10));analogo dove togliamo le posizioni, devono sempre partire per prime
  (status (step ?s) (mode computer))
  (fase (nome ricerca)) ;a differenza del caso con solo rightplaced, questo si deve attivare SOLO in ricerca
                        ;questa cosa si potrebbe evitare ma andrebbero cambiate le precondizioni di questa regola perche' quando sono in ordinamento
                        ;ignoro totalmente le posizioni possibili degli assenti e quindi potrebbero non matchare qui gli antecedenti
                        ;Ad ogni modo la posizione la rimuoviamo gia' nel conseguente della regola prova-posizione quindi sarebbe inutile
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed 0) (miss-placed ?mp))
  (test(> ?mp 0))
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto))
  
  ?fatto1 <- (possibili-posizioni (colore ?primo) (posizioni 1 $?dopo1)) 
  ?fatto2 <- (possibili-posizioni (colore ?secondo) (posizioni $?prima2 2 $?dopo2))
  ?fatto3 <- (possibili-posizioni (colore ?terzo) (posizioni $?prima3 3 $?dopo3))
  ?fatto4 <- (possibili-posizioni (colore ?quarto) (posizioni $?prima4 4))

=>
  (modify ?fatto1 (posizioni $?dopo1))
  (modify ?fatto2 (posizioni $?prima2 $?dopo2))
  (modify ?fatto3 (posizioni $?prima3 $?dopo3))
  (modify ?fatto4 (posizioni $?prima4))
)

;;REGOLE DI AGGIORNAMENTO DEI COLORI PRESENTI/ASSENTI

(defrule aggiorna-colori-veloce-negativo (declare (salience 8)) ;nel caso positivo fa partire ricerca-pegs-4
  ?fase<-(fase (nome ricerca)) 
  (status (step 5) (mode computer)) ;deve partire allo step 5
  ?testati<-(colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 3))
  
  (answer (step 4) (miss-placed ?mp) (right-placed ?rp))
  (test (eq 3 (+ ?mp ?rp)))
=>
  (modify ?testati(presenti $?presenti purple)) 
)

(defrule aggiorna-colori-positivo (declare (salience 7));se il numero di pegs aumenta, l' ultimo sostituto e' buono, il rimosso e' cattivo
  (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp1) (miss-placed ?mp1)) ;;prendi gli ultimi due guess fatti
  (answer (step ?s2&:(eq (- ?s 2) ?s2)) (right-placed ?rp2) (miss-placed ?mp2))
  (test(> (+ ?rp1 ?mp1) (+ ?rp2 ?mp2)))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?buono))
  (guess (step ?s2&:(eq (- ?s 2) ?s2)) (g ?cattivo ? ? ?))

  ?testati <- (colori-testati (presenti $?p) (assenti $?a)) 
  (not (test (member$ ?buono $?p))) ;per non far scattare piu' volte

=>
  (modify ?testati (presenti $?p ?buono) (assenti $?a ?cattivo))
)

(defrule aggiorna-colori-negativo (declare (salience 7)) ;se il numero di pegs diminuisce, l' ultimo sostituto e' cattivo, il rimosso e' buono
  (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp1) (miss-placed ?mp1))
  (answer (step ?s2&:(eq (- ?s 2) ?s2)) (right-placed ?rp2) (miss-placed ?mp2))
  (test(< (+ ?rp1 ?mp1) (+ ?rp2 ?mp2)))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?cattivo))
  (guess (step ?s2&:(eq (- ?s 2) ?s2)) (g ?buono ? ? ?))

  ?testati <- (colori-testati (presenti $?p) (assenti $?a))
  (not (test (member$ ?buono $?p))) ;per non far scattare piu' volte la regola

=>
  (modify ?testati (presenti $?p ?buono) (assenti $?a ?cattivo))
)

(defrule aggiorna-colori-uguali (declare (salience 7)) ;se il numero di pegs non cambia, salvo la coppia per dopo
  (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp1) (miss-placed ?mp1))
  (answer (step ?s2&:(eq (- ?s 2) ?s2)) (right-placed ?rp2) (miss-placed ?mp2))
  (test(eq (+ ?rp1 ?mp1) (+ ?rp2 ?mp2)))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?colore1))
  (guess (step ?s2&:(eq (- ?s 2) ?s2)) (g ?colore2 ? ? ?))

  ?cc <- (coppie-counter (counter ?c))

  (not (coppia (colori ?colore1 ?colore2))) ;per non far scattare la regola piu' volte (non esiste gia' la coppia)

=>
  (assert (coppia (id (+ ?c 1)) (colori ?colore1 ?colore2)))
  (modify ?cc (counter (+ ?c 1))) ;incremento il contatore delle coppie
)

(defrule aggiorna-colori-coppie-2-positivo (declare (salience 8)) ;caso peggiore con due coppie con soluzione allos step 6
  ?fase <- (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 5))

  (coppie-counter (counter 2)) ;devo avere 2 coppie
  
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test (eq 3 (+ ?rp ?mp)))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?buono))
  (coppia (colori ?buono ?colore2)) ;prendo l' altro colore della coppia
  ?testati <- (colori-testati (presenti $?p))
=>
  (modify ?testati (presenti $?p ?buono ?colore2))
)

(defrule aggiorna-colori-coppie-2-negativo (declare (salience 8)) ;non deve permettere l' aggiornamento dei colori
  ?fase <- (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 5)) ;deve partire solo dopo lo step 5

  (coppie-counter (counter 2)) ;devo avere 2 coppie
  
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test (eq 2 (+ ?rp ?mp)))
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?cattivo))

  (coppia (colori ?buono1 ?buono2)) 
  (test (neq ?buono1 ?cattivo)) ;prendo l' altra coppia
  ?testati <- (colori-testati (presenti $?p))
=>
  (modify ?testati (presenti $?p ?buono1 ?buono2))
)

;;REGOLA DI CAMBIO FASE DA RICERCA A ORDINAMENTO

(defrule cambio-fase (declare (salience 100))
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))
  (colori $?colori)

  ?testati <- (colori-testati (presenti ?p1 ?p2 ?p3 ?p4))
=>
  (printout t  "(" ?s ") I colori sono: " ?p1 " " ?p2 " " ?p3 " " ?p4 crlf)

  (modify ?testati (assenti (delete-member$ $?colori ?p1 ?p2 ?p3 ?p4)))
  (modify ?fase (nome ordinamento))
)
;;CASO SPECIALE CON 4/0 PEGS IN RICERCA COLORE

(defrule ricerca-pegs-4 (declare (salience 9)) ;ci deve essere una regola che aggiorna sempre le info sulle posizioni (ha salience 10)
                                              ;questa deve partire dopo
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))

  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test(eq (+ ?rp ?mp) 4))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto)) ;sono tutti e quattro presenti
  ?testati <- (colori-testati)

  (colori $?colori)

=>
  (modify ?testati (presenti ?primo ?secondo ?terzo ?quarto))
)


(defrule ricerca-pegs-0 (declare (salience 9))
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))

  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed 0) (miss-placed 0)) ;sono tutti e 4 assenti
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto)) 

  ?testati <- (colori-testati)
  ;mi devo prendere gli altri colori
  (colori $?colori)
=>
  (modify ?testati (presenti (delete-member$ $?colori ?primo ?secondo ?terzo ?quarto)))
)

;;REGOLE CHE GENERANO I GUESS

(defrule ricerca-0
  (status (step 0) (mode computer))
=>
  (assert(guess (step 0) (g blue green red yellow))) ;i primi 3 step sono standard a meno che non trovo 0/4 pegs
                                                            ;il quarto step potrei aver trovato gia' 3 buoni
                                                            ;e quindi trovare l' ultimo per esclusione tra gli ultimi
                                                            ;2 rimasti
  (pop-focus)
)

(defrule ricerca-1
  (status (step 1) (mode computer))
  (fase (nome ricerca))
=>
  (assert(guess (step 1) (g green red yellow orange)))
  (pop-focus)
)

(defrule ricerca-2
  (status (step 2) (mode computer))
  (fase (nome ricerca))
=>
  (assert(guess (step 2) (g red yellow orange white)))
  (pop-focus)
)

(defrule ricerca-3
  (status (step 3) (mode computer))
  (fase (nome ricerca))
=>
  (assert(guess (step 3) (g yellow orange white black)))
  (pop-focus)
)

(defrule ricerca-4-veloce (declare (salience 5)) ;deve partire dopo l'update ma prima di ricerca-4
                                                 ;questo e' il caso fortunato in cui arrivo allo step 4
                                                 ;con 3 presenti e 3 assenti. Ne provo uno, se fallisce e' l' altro
                                                 ;in particolare provo con yellw, altrimenti e' purple
  (status (step 4) (mode computer))
  (fase (nome ricerca))
  (colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 3))
=>
  (assert(guess (step 4) (g $?presenti yellow))) ;ci sara' un aggiorna-testati-veloce che controlla che allo step 3 presenti
                                                 ;avesse lunghezza 3 (e anche questo avra' salience 5)
  (pop-focus)
)


(defrule ricerca-4
  (status (step 4) (mode computer))
  (fase (nome ricerca))
=>
  (assert(guess (step 4) (g orange white black purple)))
  (pop-focus)
)

(defrule ricerca-coppie-2
  (status (step 5) (mode computer))
  (fase (nome ricerca))
  (coppia (colori ?c1 ?))
  (coppie-counter (counter 2)) ;devo avere 2 coppie
  (colori-testati (presenti ?p1 ?p2 $?) (assenti ?a $?))
=>
  (assert(guess (step 5) (g ?p1 ?p2 ?a ?c1)))
  (pop-focus)
)

(defrule ricerca-coppie-4
  (status (step 5) (mode computer))
  (fase (nome ricerca))
  (coppie-counter (counter 4))
  (coppia (id 1) (colori $?colori1))
  (coppia (id 2) (colori $?colori2))
=>
  (assert (guess (step 5) (g $?colori1 $?colori2)))
  (pop-focus)
)

(defrule ricerca-coppie-4-lento (declare (salience 8));sono tornato da ricerca-coppie-4 e non ho trovato 0/4 pegs 
  (status (step 6) (mode computer))
  (fase (nome ricerca))
  (coppie-counter (counter 4))
  (coppia (id 1) (colori $?colori1))
  (coppia (id 3) (colori $?colori2))
=>
  (assert (guess (step 6) (g $?colori1 $?colori2)))
  (pop-focus)
)

(defrule ricerca-coppie-4-proseguimento (declare (salience 8));sono tornato da ricerca-coppie-4-lento
                                                              ;significa che le coppie 2 e 3 hanno lo stesso valore
                                                              ;ultima ricerca possibile, avro' per forza 0/4 pegs e cambiero' fase automaticamente
  (status (step 7) (mode computer))
  (fase (nome ricerca))
  (coppie-counter (counter 4))
  (coppia (id 2) (colori $?colori1))
  (coppia (id 3) (colori $?colori2))
=>
  (assert (guess (step 7) (g $?colori1 $?colori2)))
  (pop-focus)
)


(deffacts initial-facts
  (fase (nome ricerca))
  (colori-testati)
  (colori blue green red yellow orange white black purple)
  (coppie-counter (counter 0))
  
  (possibili-posizioni (colore blue) (posizioni 1 2 3 4))
  (possibili-posizioni (colore green) (posizioni 1 2 3 4))
  (possibili-posizioni (colore red) (posizioni 1 2 3 4))
  (possibili-posizioni (colore yellow) (posizioni 1 2 3 4))
  (possibili-posizioni (colore orange) (posizioni 1 2 3 4))
  (possibili-posizioni (colore white) (posizioni 1 2 3 4))
  (possibili-posizioni (colore black) (posizioni 1 2 3 4))
  (possibili-posizioni (colore purple) (posizioni 1 2 3 4))  
)


 



