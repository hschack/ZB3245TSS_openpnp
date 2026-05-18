; /sys/homez.g
; Kaldes når kun Z-aksen skal homes (f.eks. ved opstart eller efter nødstop)

G91                             ; Relativ positionering
G1 H1 Z30 F1200                 ; Søg opad mod endstoppet (PG10) og stop øjeblikkeligt ved klik
G90                             ; Absolut positionering

G92 Z16                         ; Fortæl firmwaren, at vi nu står i maksimal højde (16 mm i toppen)

