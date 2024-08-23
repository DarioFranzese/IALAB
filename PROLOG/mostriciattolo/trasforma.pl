%Il primo MovibiliOrdinati e' solo la lista che ci da l' ordine in cui spostare i pezzi, il secondo invece e' l' elenco dei pezzi ordinati in real time
%che poi nel caso base verra' ricopiato nella variabile finale. E' un po' onerosa come soluzione, ma e' per evitare di avere altre variabili ancora
trasforma(Azione, Corrente, Movibili, NuovoStato, NuoviMovibili):- %NuoviMovibili dovrebbe avere sempre il martello in testa (se non e' stato preso)
    ordina(Azione, [corrente(Corrente) | Movibili], MovibiliOrdinati), %il predicato corrente verra' usato per identificare l' agente
    sposta(Azione, MovibiliOrdinati, MovibiliOrdinati, _, NuovoStato, NuoviMovibili), !. %questo wrapper prendera' un movibile alla volta e lo spostera', restituendo poi i NuoviMovibili (potenzialmente prendiamo il martello
                                                                                        %oppure rompiamo il ghiaccio) e il nuovo stato dell' agente.
                                                                                        %Questo potra' chiamare spostaAgente o spostaOggetto a seconda se l' elemento corrente della lista sia uno o l' altro
                                                                                        %Questo e' necessario per il modo in cui affrontano gli ostacoli i due tipi di movibili
                                                                        

%CASO BASE
%credo vada aggiunto qualche cut
%abbiamo spostato tutti i movibili (Movibili=[]) e quindi rimuoviamo il corrente dai nuovi movibili e mettiamo il martello in testa (cosa che trasforma deve garantire)
%TESTATO FUNZIONA
%caso in cui il martello non e' stato preso (lo rimetto in testa)
sposta(_, [], NuoviMovibili, NuovoStato, NuovoStato, [martello(X) | NuoviMovibiliFinali]):-
    delete(NuoviMovibili, corrente(_), NM),
    getPosizioneMartello(NM, X),
    delete(NM, martello(_), NuoviMovibiliFinali), !. %rimuovilo dalla lista per essere sicuro stia solo in testa
    
%caso in cui getPosizioneMartello fallisce (il martello e' stato preso)    
sposta(_, [], Movibili, NuovoStato, NuovoStato, NuoviMovibili):-
    delete(Movibili, corrente(_), NuoviMovibili).


%TESTATO CON spostaAgente fake E FUNZIONA
sposta(Azione, [ corrente(X) | CodaMovibili], TempMov, _, NuovoStato, NuoviMovibili):-
    spostaAgente(Azione, X, TempMov, NuovoStatoAgente, MovibiliPostAgente), %questo e' l'unico predicato che dovra' modificare NuovoStato
    delete(MovibiliPostAgente, corrente(X), NuovaCodaMovibili), %Movibili post agente sara' l' elenco dei movibili potenzialmente primo di ghiaccio e martello, tuttavia contiene ancora la posizione
                                                                       %del corrente, che va quindi tolta per poi aggiungerci il nuovo corrente
    sposta(Azione, CodaMovibili, [corrente(NuovoStato) | NuovaCodaMovibili], NuovoStatoAgente, NuovoStato, NuoviMovibili). %metto il corrente in testa tanto e' indifferente
                                                                                                         %Occhio All' utilizzo di NuovoStato non mi convince

%TESTATO CON spostaOggetto fake E FUNZIONA
sposta(Azione, [ gemma(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    delete(TempMov, gemma(X), NewTempMov),
    sposta(Azione, CodaMovibili, [gemma(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).

sposta(Azione, [ avversario(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    spostaOggetto(Azione, X, TempMov, NuovoStatoOggetto), %questo predicato non dovrebbe modificare i Movibili e quindi non ci deve dare in output un nuovo valore di TempMov
    delete(TempMov, avversario(X), NewTempMov),
    sposta(Azione, CodaMovibili, [avversario(NuovoStatoOggetto) | NewTempMov], TempNuovoStato, NuovoStato, NuoviMovibili).

%questo serve perche' nei movibili ci sono anche ghiaccio e martello che in realta' NON si muovono, quindi anziche' creare un' altra lista ancora
%ne teniamo solo una che quando trova questi due tipi di oggetti va avanti e basta
sposta(Azione, [ martello(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    sposta(Azione, CodaMovibili, [ martello(X) | TempMov] , TempNuovoStato, NuovoStato, NuoviMovibili).

sposta(Azione, [ ghiaccio(X) | CodaMovibili], TempMov, TempNuovoStato, NuovoStato, NuoviMovibili):-
    sposta(Azione, CodaMovibili, [ ghiaccio(X) | TempMov] , TempNuovoStato, NuovoStato, NuoviMovibili).


getPosizioneMartello([martello(X)|_], X).
getPosizioneMartello([_|T], X):- getPosizioneMartello(T, X).