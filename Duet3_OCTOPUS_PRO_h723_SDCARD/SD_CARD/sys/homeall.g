;; /sys/homeall.g
G91                             ; Relativ positionering
G1 H1 Z30 F1200                 ; KØR Z HELT I TOP: Søg mod endstop (PG10) og stop med det samme ved klik
G90                             ; Absolut positionering
G92 Z16                         ; Sæt Z til dens absolutte maks-højde (16mm)

G91                             ; Relativ positionering til X og Y
G1 H1 X-450 Y-550 F3000         ; Hurtigt træk mod X og Y endstops (første pass)
G1 X5 Y5 F6000                  ; Gå 5 mm fri
G1 H1 X-10 Y-10 F360            ; Langsomt og præcist klik mod X og Y (andet pass)
G90                             ; Absolut positionering

; Nulstil alle akser (XYZ til reelle værdier, rotationsakser UVWA til 0)
; Her fortæller vi firmwaren, at vi står præcis i det mekaniske nulpunkt (0,0) på switchene
G92 X0 Y0 Z16 U0 V0 W0 A0 B0

; --- NYT: Ryk 5 mm frem fra endswitchene ---
G1 X5 Y5 F3000                  ; Kør roligt ud til koordinat X5, Y5, så switchene slippes

M117 Maskine homed og trukket fri!

