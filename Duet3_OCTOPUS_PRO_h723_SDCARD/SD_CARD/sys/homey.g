; /sys/homey.g
; Kaldes når kun Y-aksen skal homes

G91                             ; Relativ positionering
G1 H1 Y-550 F3000               ; Første pass: Kør hurtigt mod Y-endstop (PG9)
G1 Y5 F6000                     ; Gå 5 mm fri
G1 H1 Y-10 F360                 ; Andet pass: Klik langsomt og præcist
G90                             ; Absolut positionering

G92 Y0                          ; Sæt Y-aksens nulpunkt lige her på switchen
G1 Y5 F3000                     ; Ryk de 5 mm frem, så switchen slippes og der er frigang
