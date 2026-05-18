; /sys/pause.g
; Kaldes hvis en kørsel pauses (f.eks. via Duet Web Control eller OpenPnP)

G91                             ; Relativ positionering
G1 Z5 F2000                     ; Løft lynhurtigt Z 5 mm op for at trække dyserne fri af alt
G90                             ; Absolut positionering

