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
  ;forse gli assenti potrebbero anche essere solo uno, per creare allo step 5 la combinazione P P NP X per testare X
  ;pero' se ce li segniamo tutti possiamo fare una strategia simile a quella del bro per trovare le posizioni
  ;il problema principale e' che noi non abbiamo tutti quei tentativi, e vabbe
)

(deftemplate coppia ;coppia che salvo nel caso in cui nei primi 5 step non ho trovato tutti i colori presenti
  (multislot colori (allowed-values blue green red yellow orange white black purple) (cardinality 2 2))
)

(deftemplate possibili-posizioni ;utilizzato per la fase di ordinamento
  (slot colore (allowed-values blue green red yellow orange white black purple))
  (multislot posizioni (allowed-values 1 2 3 4))
)

(deftemplate fase ;la strategia si suddivide in due fasi:ricerca dei colori e ordinamento di questi
  (slot nome (allowed-values ricerca ordinamento))
)
;;SALIENCE: L' ordine delle operazioni (di ricerca) e': POSIZIONI -> PRESENTI -> NUOVO GUESS

(defrule aggiorna-posizioni-rp (declare (salience 10));in questo caso abbiamo trovato solo rightplaced
  (fase (nome ricerca)) ;per il momento metto fase ricerca perche' non sappiamo ancora bene come gestire l' ordinamento
                        ;ma nulla ci vieta di utilizzarla anche in quel caso (anzi probabilmente faremo cosi')
  (status (step ?s) (mode computer))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test(eq ?mp 0))
  (test(> ?rp 0)) ;da controllare sta sintassi la sto facendo al volo cosi' al meno si capisce la logica

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto))
  ?fatto1 <- (possibili-posizioni (colore ?primo) (posizioni 1 $?dopo1)) 
  ?fatto2 <- (possibili-posizioni (colore ?secondo) (posizioni $?prima2 2 $?dopo2))
  ?fatto3 <- (possibili-posizioni (colore ?terzo) (posizioni $?prima3 3 $?dopo3))
  ?fatto4 <- (possibili-posizioni (colore ?quarto) (posizioni $?prima4 4))

=>
  (modify ?fatto1 (posizioni 1))
  (modify ?fatto2 (posizioni 2))
  (modify ?fatto3 (posizioni 3))
  (modify ?fatto4 (posizioni 4))
)

(defrule aggiorna-posizioni-mp (declare (salience 10));analogo dove togliamo le posizioni, devono sempre partire per prime
  (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test(> ?mp 0))
  (test(eq ?rp 0)) 
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

(defrule aggiorna-colori-veloce-positivo (declare (salience 7)) ;se sono nel caso "veloce", se ho 4 rp significa che l' ultimo colore aggiunto e' corretto (e' sempre black)
  ?fase<-(fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  ?testati<-(colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 3))
  
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp))
  (test (eq ?rp 4))
=>
  (modify ?testati(presenti $?presenti yellow)) ;non ho aggiunto purple agli assenti perche' e' inutile 
  (modify ?fase (nome ordinamento))
)

(defrule aggiorna-colori-veloce-negativo (declare (salience 7))
  ?fase<-(fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  ?testati<-(colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 3))
  
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp))
  (test (eq ?rp 3))
=>
  (modify ?testati(presenti $?presenti purple)) 
  (modify ?fase (nome ordinamento))
)

(defrule aggiorna-colori-positivo (declare (salience 7));se il numero di pegs aumenta, l' ultimo sostituto e' buono, il rimosso e' cattivo
  (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp1) (miss-placed ?mp1))
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

  (not (coppia (colori ?colore1 ?colore2))) ;per non far scattare la regola piu' volte

=>
  (assert (coppia (colori ?colore1 ?colore2)))
)

(defrule aggiorna-colori-6-positivo ;caso peggiore con due coppie con soluzione allos step 6
  ?fase <- (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test (eq 3 (+ ?rp ?mp)))
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?buono))
  (coppia (colori ?buono ?colore2)) ;prendo l' altro colore della coppia
  ?testati <- (colori-testati (presenti $?p))
=>
  (modify ?testati (presenti $?p ?buono ?colore2))
  (modify ?fase (nome ordinamento))
)

(defrule aggiorna-colori-6-negativo 
  ?fase <- (fase (nome ricerca)) 
  (status (step ?s) (mode computer))
  (test(> ?s 1))
  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test (eq 2 (+ ?rp ?mp)))
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ? ? ? ?cattivo))
  (coppia (colori ?buono1 ?buono2)) 
  (test (neq ?buono1 ?cattivo)) ;prendo l' altra coppia
  ?testati <- (colori-testati (presenti $?p))
=>
  (modify ?testati (presenti $?p ?buono1 ?buono2))
  (modify ?fase (nome ordinamento))
)

(defrule cambio-fase 100
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))
  (colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 4))
=>
  (modify ?fase (nome ordinamento))
)

(defrule ricerca-pegs-4  ;ci deve essere una regola che aggiorna sempre le info sulle posizioni (ha salience 10)
                                              ;questa deve partire dopo
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))

  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed ?rp) (miss-placed ?mp))
  (test(eq (+ ?rp ?mp) 4))

  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto)) ;sono tutti e quattro presenti
  ?testati <- (colori-testati)

  (colori $?prima1 ?primo $?prima2 ?secondo $?prima3 ?terzo $?prima4 ?quarto $?dopo) ;praticamente prendi gli altri 4 colori

=>
  (modify ?testati (presenti ?primo ?secondo ?terzo ?quarto) (assenti $?prima1 $?prima2 $?prima3 $?prima4))
  (modify ?fase (nome ordinamento))
)

(defrule ricerca-pegs-0 (declare (salience 10))
  ?fase <- (fase (nome ricerca))
  (status (step ?s) (mode computer))

  (answer (step ?s1&:(eq (- ?s 1) ?s1)) (right-placed 0) (miss-placed 0)) ;sono tutti e 4 assenti
  (guess (step ?s1&:(eq (- ?s 1) ?s1)) (g ?primo ?secondo ?terzo ?quarto)) 

  ?testati <- (colori-testati)
  (colori $?prima1 ?primo $?prima2 ?secondo $?prima3 ?terzo $?prima4 ?quarto $?dopo) ;praticamente prendi gli altri 4 colori

=>
  (modify ?testati (presenti $?prima1 $?prima2 $?prima3 $?prima4) (assenti ?primo ?secondo ?terzo ?quarto))
  (modify ?fase (nome ordinamento))
)

(defrule ricerca-0
  (status (step 0) (mode computer))
  (colori ?primo ?secondo ?terzo ?quarto $?)
=>
  (assert(guess (step 0) (g blue green red yellow))) ;i primi 3 step sono standard a meno che non trovo 0/4 pegs
                                                            ;il quarto step potrei aver trovato gia' 3 buoni
                                                            ;e quindi trovare l' ultimo per esclusione tra gli ultimi
                                                            ;2 rimasti
  (pop-focus)
)

(defrule ricerca-1
  (status (step 1) (mode computer))
=>
  (assert(guess (step 1) (g green red yellow orange))) ;se si vuole fare una roba piu' elegante si puo' usare  
                                                     ;una sintassi simile a quella del bro con l' indice bla bla
                                                     ;secondo me abbastanza inutile onestamente
  (pop-focus)
)

(defrule ricerca-2
  (status (step 2) (mode computer))
=>
  (assert(guess (step 2) (g red yellow orange white)))
  (pop-focus)
)

(defrule ricerca-3
  (status (step 3) (mode computer))
=>
  (assert(guess (step 3) (g yellow orange white black)))
  (pop-focus)
)

(defrule ricerca-4-veloce (declare (salience 5)) ;deve partire dopo l'update ma prima di ricerca-4
                                                 ;questo e' il caso fortunato in cui arrivo allo step 4
                                                 ;con 3 presenti e 3 assenti. Ne provo uno, se fallisce e' l' altro
                                                 ;in particolare provo con black, altrimenti e' purple
  (status (step 4) (mode computer))
  (colori-testati (presenti $?presenti))
  (test(eq (length$ $?presenti) 3))
=>
  (assert(guess (step 4) (g $?presenti yellow))) ;ci sara' un aggiorna-testati-veloce che controlla che allo step 3 presenti
                                              ;avesse lunghezza 3 (e anche questo avra' salience 5)
  (pop-focus)
)


(defrule ricerca-4 ;caso peggiore
  (status (step 4) (mode computer))
=>
  (assert(guess (step 4) (g orange white black purple)))
  (pop-focus)
)

(defrule ricerca-5 ;caso peggiore
  (status (step 5) (mode computer))
  (coppia (colori ?c1 ?c2))
  (colori-testati (presenti ?a ?b $?) (assenti ?c $?))
=>
  (assert(guess (step 5) (g ?a ?b ?c ?c1)))
  (pop-focus)
)


(deffacts initial-facts
  (fase (nome ricerca))
  (colori-testati)
  (colori blue green red yellow orange white black purple)
  
  (possibili-posizioni (colore blue) (posizioni 1 2 3 4))
  (possibili-posizioni (colore green) (posizioni 1 2 3 4))
  (possibili-posizioni (colore red) (posizioni 1 2 3 4))
  (possibili-posizioni (colore yellow) (posizioni 1 2 3 4))
  (possibili-posizioni (colore orange) (posizioni 1 2 3 4))
  (possibili-posizioni (colore white) (posizioni 1 2 3 4))
  (possibili-posizioni (colore black) (posizioni 1 2 3 4))
  (possibili-posizioni (colore purple) (posizioni 1 2 3 4))  
)


 



