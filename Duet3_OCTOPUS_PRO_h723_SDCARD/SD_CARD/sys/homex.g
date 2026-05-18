; /sys/homex.g
; Kaldes når kun X-aksen skal homes

G91                             ; Relativ positionering
G1 H1 X-450 F3000               ; Første pass: Kør hurtigt mod X-endstop (PG6)
G1 X5 F6000                     ; Gå 5 mm fri
G1 H1 X-10 F360                 ; Andet pass: Klik langsomt og præcist
G90                             ; Absolut positionering

G92 X0                          ; Sæt X-aksens nulpunkt lige her på switchen
G1 X5 F3000                     ; Ryk de 5 mm frem, så switchen slippes og der er frigang
