turtles-own[
  degree
  decided
  marked
  steps
  message
  signalling
  counterMessages
]

globals[logD  M Mlogn MAXDEGREE]


to Lubys
  clear-all-plots

 ask turtles [
    set color blue
    set decided false
    set label who
    set marked false
    set message false
    let app count link-neighbors
    set degree app
    set steps 0
  ]
  display

  ;EXCHANGE 1

  while [any? turtles with [decided = false]] [
    let marksProb 0

    ask turtles with [decided = false] [

    set message false
    if (count link-neighbors = 0) [set marked true] ;DEN EXEI GEITONES ARA MPAINEI STO MIS


    ;ORIZETE I PITHANOTITA ME TIS OPOIA THA ORIZONTAI POIOI KOMVOI THA MPOUN STO MIS KAI
    ;OI GEITONES TOUS THA APORIFTHOUN
    if(count link-neighbors != 0)[
     set degree ((count link-neighbors) - (count link-neighbors with [color = yellow])) ;ORIZOUME TO DEGREE TOU KAI VASI AUTOU THN PITHANOTITA TOU
      set marksProb (1 / (2 * degree))

        ifelse random-float 1.0 < marksProb [
        set marked true
        ask link-neighbors with [decided = false and message = false] [ set message true  ]
        ]
       [set marked false]

    ]

    set counterMessages  (counterMessages + count (turtles with [decided = false and message = true]))
    ;METRAME POSA STEPS GINONTAI SE KATHE LOUPA
    set steps (steps + 1)

  ]

  ;RWTAME TOUS KOMVOUS POY DEN EXOUN APOFASISTEI ALLA EINAI MARKARISMENOI
  ;OTAN EXOUN APOFASISEI OLOI OI KOMVOI AN THA EINAI MESA STO MIS
  ;TOTE THA TELEIWSEI I EKTELESI
  ask turtles with [decided = false and marked = true] [
    let finish 1
    let neighborList []
    ask link-neighbors [
      set neighborList lput degree neighborList ;FTIAXNOUME MIA LISTA ME TA RANK TWN GEITONWN
    ]

    ;GIA KATHE YPOPSIFIOUS KOMVOUS POY THELOUN NA MPOUNE STO MIS SULLEGOUME TOUS GEITONES TOUS
    ; STO 1o ROUND ELEGXOUME AN TA MINIMATA TWN GEITONWN EINAI MIKROTERA APO TO TOU YPOPSIFIOU KOMVOU
    without-interruption [

      foreach neighborList [ ?1 ->
        let ctrl 0
        if(degree < ?1) [
          ask link-neighbors with [degree = ?1] [
            if (marked = true) [set ctrl 1]

          ]
          if (ctrl = 1) [
            set marked false
            set finish 0
            set message false
          ]

          ]
        if (degree = ?1 )[
         let id who
         set ctrl 0
         ask link-neighbors with [degree = ?1] [
          if (id > who) [
            set marked false
            set ctrl 1
            ]
         ]
         if (ctrl = 0) [
           set marked false
              set message false
           ]

        ]
      ]
    ]

  ;AN ONTWS O YPOPSIFIOS KOMVOS EINAI KATALLILO NA MPEI STO MIS
  ;ENERGOPOIEITE TO 2o ROUND KAI O KOMVOS ORISTIKOPOIEITE MESA STO MIS ME XRWMA KOKKINO
  ;STELNEI MINIMA STA LINK-GEITONES TOY KAI TOUS KANEI KITRINOYS DILADI TOUS APENERGOPOIEI KAI DEN THA
  ;MPOYNE STO MIS
  ;EXCHANGE 2

  if (finish = 1 and marked = true) [

    set color red
    set decided true

    ask my-links [
      set color yellow
    ]

    ask link-neighbors with [decided = false] [
      set color green
      set decided true
      set degree 0
      ask my-links [
        set color yellow
      ]

    ]

  ]
  display
  ]

    tick
  ]


end




to bioDCM
  clear-all-plots


 ask turtles [
    set color blue
    set decided false
    set label who
    set marked false
    let app max[count link-neighbors] of turtles
    set degree app
    set steps 0
    set counterMessages 0
    set message false
  ]
  display



  setup-logD
  setup-Mlogn
  let i 0

  while[ i <= item 0 logD][

      let j 0
      while[ j <= item 0 Mlogn and any? turtles with [decided = false]][


      let marksProb 0
      ask turtles with [decided = false] [

        set message false
        ;EXCHANGE1
        set marksProb (1 / (2 ^ (log MAXDEGREE 2 - 1)))

        ifelse random-float 1.0 < marksProb [
          set marked true
          ask link-neighbors with [decided = false] [
              set message true
                 ]
          ]
             [set marked false]


        set counterMessages  (counterMessages + count (turtles with [decided = false and message = true]))
        set steps (steps + 1)
      ]



      ;EXCHANGE2
        ask turtles with [decided = false and marked = true] [

          ifelse message = false[
           set color red
           set decided true


          ask link-neighbors with [decided = false] [
              set color green
              set decided true
              ask my-links [  set color yellow ]
            ]
          ]

          [set marked false ]

        ]

        set j j + 1
      tick
    ]
      set i i + 1
    ]


   display

end



;;firstLoop
to setup-logD
  set MAXDEGREE max[count link-neighbors] of turtles
  set logD []
  let i 0
  while [i < log MAXDEGREE 2 + 1][
    set logD fput i logD
    set i i + 1]

end


;;SecondLoop
to setup-Mlogn
  let NUMOFNODES number-of-nodes

  set M 34
  set Mlogn []
  let i 1
  while [i < M * log NUMOFNODES 2 ][
    set Mlogn fput i Mlogn
    set i i + 1]

end








to local-probabilities-DCM
   clear-all-plots


 ask turtles [
    set color blue
    set decided false
    set label who
    set marked false
    let app max[count link-neighbors] of turtles
    set degree app
    set steps 0
    set message false
  ]
  display


  let p 1 / 2

  while[any? turtles with [decided = false]][

        ask turtles with [decided = false] [

        set message false
        ifelse random-float 1.0 < p [
          set marked true

          ask link-neighbors with [decided = false] [
              set message true]
          ]
             [set marked false]

      ifelse any? link-neighbors with [marked = true][

        set marked false
        set p p / 2

      ]
      [
        set p min  list (2 * p)  (1 / 2)

      ]

        set counterMessages  (counterMessages + count (turtles with [decided = false and message = true]))
        set steps (steps + 1)
      ]

      ;EXCHANGE2
        ask turtles with [decided = false and marked = true] [

          ifelse marked = true[
           set color red
           set decided true

            ask my-links [set color yellow]

            ask link-neighbors with [decided = false] [
              set color green
              set decided true
              set degree 0
              ask my-links [  set color yellow ]
            ]
          ]

          [set marked false ]

        ]



    ]


   display

end






to Page13-DCM
   clear-all-plots


 ask turtles [
    set color blue
    set decided false
    set label who
    set marked false
    let app max[count link-neighbors] of turtles
    set degree app
    set steps 0

    set message false
  ]
  display


  let p 1 / max[count link-neighbors] of turtles

  while[any? turtles with [decided = false]][

        ask turtles with [decided = false] [

        ifelse random-float 1.0 < p [
          set marked true

          ]
         [set marked false]

      ifelse any? link-neighbors with [marked = true][ set marked false

      ] [set marked true]



      ;EXCHANGE2
        ask turtles with [decided = false and marked = true] [

          ifelse marked = true[
           set color red
           set decided true

            ask my-links [set color yellow]

            ask link-neighbors with [decided = false] [
              set color green
              set decided true
              set degree 0
              ask my-links [  set color yellow ]
            ]
          ]

          [set marked false ]


        set steps (steps + 1)
        ]


    ]

  ]
   display

end






















to create-graph
  __clear-all-and-reset-ticks

  set-default-shape turtles "circle"

  ask patches [set pcolor white]
  crt number-of-nodes [
    set color blue
    set decided false
  ]

  if not any? turtles [ stop ]

  ifelse graph-model = "random"
  [ do-rand-layout ][

    ifelse graph-model = "Erdos-Renyi"
    [do-erdos-layout]
    [ ifelse graph-model = "circle"
    [ do-circle-layout ]
      [ user-message word "Layout sconosciuto: " graph-model ] ] ]
end

;random layout
to do-rand-layout
  repeat 50 [
  layout-spring turtles links 0.5 (sqrt count links) 0.5
  ]
  while [(count links < number-of-links) and (count links <= ((count turtles)*(count turtles - 1)/ 2) - 1)][
    ask one-of turtles
    [ create-link-with one-of other turtles ]
   ]
end

;circle layout
to do-circle-layout
  layout-circle turtles max-pxcor
  while [(count links < number-of-links) and (count links <= ((count turtles)*(count turtles - 1)/ 2) - 1)][
    ask one-of turtles
    [ create-link-with one-of other turtles ]
   ]
end

;Erdos-Renyi graph
to do-erdos-layout
  layout-circle turtles max-pxcor
  ;; Now give each pair of turtles an equal chance
  ;; of creating a link
  ask turtles [
    ;; we use "self > myself" here so that each pair of turtles
    ;; is only considered once
    ifelse prob_chooser = true [create-links-with turtles with [self > myself and random-float 1.0 < probability]]
                               [create-links-with turtles with [self > myself and random-float 1.0 < ((c-value / count turtles) * ln count turtles)]]
  ]
end





@#$#@#$#@
GRAPHICS-WINDOW
492
10
929
500
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-18
18
0
0
1
ticks
30.0

BUTTON
323
196
386
229
Run
Lubys
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
102
184
135
number-of-nodes
number-of-nodes
2
300
40.0
1
1
NIL
HORIZONTAL

SLIDER
12
158
184
191
number-of-links
number-of-links
1
500
500.0
1
1
NIL
HORIZONTAL

BUTTON
271
130
440
163
Generate Graph
create-graph
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
12
10
185
55
graph-model
graph-model
"random" "circle" "Erdos-Renyi"
1

SLIDER
16
350
188
383
probability
probability
0
1
0.1
0.05
1
NIL
HORIZONTAL

MONITOR
1033
47
1144
92
number of rounds
max [steps] of turtles
17
1
11

SWITCH
32
255
164
288
prob_chooser
prob_chooser
0
1
-1000

SLIDER
16
302
188
335
c-value
c-value
1
10
2.0
1
1
NIL
HORIZONTAL

MONITOR
1072
343
1129
388
joined
count turtles with [color = red]
17
1
11

MONITOR
1063
291
1132
336
not joined
count turtles with [color = green]
17
1
11

BUTTON
314
295
396
328
2erwtima
bioDCM\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
300
348
382
381
3erwtima
local-probabilities-DCM
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
301
432
380
465
bonus13
Page13-DCM
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
151
594
351
744
run
Time
decided
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [decided = 1]"

MONITOR
1011
112
1170
157
Total Number of Messages
max [counterMessages] of turtles
17
1
11

MONITOR
1251
198
1371
243
Total Bit/Messages 
max [counterMessages] of turtles
17
1
11

@#$#@#$#@
## CHE COS'E'?

Questo modello simula l'esecuzione dell'algoritmo Fast MIS from 1986 per il calcolo del Maximal Independent Set su grafi. I grafi nel modello sono grafi generati in maniera casuale scegliendo il numero di nodi e archi oppure sono grafi generati scegliendo soltanto il numero dei nodi e calcolati applicando il modello probabilistico di Erdos-Renyi.
In particolare si vuole simulare il comportamento di tale algoritmo in un contesto distribuito.  
La versione di riferimento e' quella presentata in [1], che garantisce un approccio probabilistico alla soluzione del problema. 

L' algoritmo opera su round sincroni che vengono raggruppati in fasi.  
Ogni fase è composta dai seguenti tre passi:

1) Ogni nodo v marca se stesso con probabilità pari a 1/(2d(v)) dove d(v) indica il grado attuale del nodo v.
2) Se nessun nodo vicino di v con più alto grado è marcato allora v fa join nel MIS. Altrimenti v "smarca" se stesso (fa unmark di se stesso). Se due nodi vicini hanno lo stesso grado allora si considera l'identificatore dei nodi.
3) Cancella tutti i nodi che hanno fatto join nel MIS e anche i loro vicini dato che non potranno più far parte del MIS.

L'algoritmo termina quando ogni nodo ha deciso se far parte o meno del Maximal Independent Set. Analizzando la correttezza dell'algoritmo abbiamo che grazie ai passi 1 e 2 siamo sicuri che se un nodo v entra a far parte del MIS allora i vicini di v non entreranno contemporaneamente a far parte anch'essi del MIS. Inoltre grazie al terzo passo siamo sicuri che se v entra a far parte del MIS, allora i suoi vicini non potranno mai più tentare di entrare nell'insieme. Dopo questa analisi, siamo certi quindi che l'algoritmo effettivamente è corretto.

## COME FUNZIONA

Sono presenti tre procedure. La procedura "fast_mis_1986" implementa effettivamente l'algoritmo. A ciascun agente sono assegnate quattro variabili locali:

- degree: variabile intera che indica il grado corrente del nodo. 
- decided: variabile booleana che indica se il nodo ha deciso di entrare a far parte o meno del MIS.
- marked: variabile booleana che indica se il nodo è marcato o no nella fase corrente dell'algoritmo.
- steps: variabile intera che memorizza il numero di fasi che il nodo ha effettuato. Questa variabile non è vitale per l'esecuzione dell'algoritmo ma è stata inserita per una successiva analisi delle performance.

Per implementare il primo passo dell'algoritmo, abbiamo che la scelta probabilistica (basata sempre sul grado corrente del nodo) viene effettuata utilizzando la funzione random-float che estrae un numero casuale compreso tra 0 e 1. In questo modo il nodo marca se stesso solo se tale valore è minore di 1/(2d(v)).
Per il secondo passo invece ogni agente che non ha ancora deciso di entrare o meno a far parte del MIS ma che ha marcato se stesso, interroga concorrentemente i suoi vicini costruendo una lista in cui ogni elemento indica il grado di un vicino. Una volta compilata tale lista, l'agente la scorre controllando se esistono altri vicini con grado maggiore o uguale al suo. Se trova anche soltanto un nodo con grado maggiore e che è anch'esso marcato allora deve necessariamente "smarcarsi"; se invece trova un vicino con lo stesso grado e marcato allora chi dei due ha l'id più basso deve "smarcarsi". Gli agenti che dopo questo controllo restano ancora marcati entreranno a far parte del MIS e disattiveranno inoltre anche i loro vicini che rispettando l'algoritmo non possono entrare nel MIS. Viene così implementato anche il terzo passo dell'algoritmo.
Quando non ci sono più nodi il cui valore di decided è uguale a false l'algoritmo termina.

In "create-graph" sono presenti tutte le operazioni necessarie a creare la rete su cui verrà applicato l'algoritmo. Attraverso la variabile "graph-model" l'utente può scegliere la topologia del grafo che può essere: circle, random, oppure un grafo secondo il modello Erdos-Renyi. Il grafo quindi può essere creato in maniera random a partire dal numero di nodi e dal numero di archi specificati mediante le variabili globali "number-of-nodes" e "number-of-links", scelti dall'utente. Nel caso in cui il valore della variabile number-of-links sia maggiore del numero possibile massimo di archi presenti nel grafo, fissato il numero dei nodi, il numero di archi che vengono creati è pari al valore massimo consentito dalla topologia specificata. Oltre alla modalità random il grafo può essere creato secondo il modello Erdos-Renyi ed in questo caso verranno considerate le variabili globali "number-of-nodes" e "c-value" oppure "probability". Nel caso l'utente scelga di utilizzare la variabile "c-value" allora gli archi verrano generati con una probabilità pari a (c/n) log n. Altrimenti si può scegliere di utilizzare una probabilità indipendente dal numero di nodi ed in questo caso l'utente la può specificare grazie alla variabile "probability".

## COME USARLO

Per avviare l'algoritmo è necessario innanzitutto creare il grafo. Tale operazione viene effettuata specificando mediante gli appositi slider, il numero di nodi e di archi che si vuole creare nei layout "random" e "circle", oppure specificando il numero di nodi e la probabilità di generazione degli archi se si sceglie il modello "Erdos-Renyi". La fase di creazione del grafo termina cliccando sul bottone "Generate Graph" e viene visualizzato così il grafo scelto.  
A questo punto si può eseguire l'algoritmo cliccando sul bottone Run.


## DA NOTARE

E' da notare che dopo aver eseguito l'algoritmo, si può nuovamente premere il pulsante Run ed eseguire da capo l'algoritmo sulla stessa topologia. Questo porterà al calcolo di un nuovo MIS che può in generale essere diverso da quello di partenza. Infatti su uno stesso grafo è possibile avere più MIS validi e diversi tra di loro. L'algoritmo termina in numero atteso di passi pari ad O (log n).

## RIFERIMENTI

[1] M. Luby. A Simple Parallel Algorithm for the Maximal Independent Set Problem. In SIAM Journal on Computing, November 1986.
[2] http://dcg.ethz.ch/lectures/podc_allstars/index.html  
[3] N. Alon, L. Babai, and A. Itai. A fast and simple randomized parallel algorithm for the maximal independent set problem. Journal of Algorithms, 7(4):567-583, 1986. 
[4] A. Israeli, A. Itai. A Fast and Simple Randomized Parallel Algorithm for Maximal Matching. In Information Processing Letters volume 22(2), pages 77-80, 1986. 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
