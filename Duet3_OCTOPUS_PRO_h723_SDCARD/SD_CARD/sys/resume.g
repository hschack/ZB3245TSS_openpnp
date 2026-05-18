; /sys/resume.g
; Kaldes når en kørsel genoptages (f.eks. via Duet Web Control eller OpenPnP)

G91                             ; Relativ positionering
G1 Z-5 F2000                    ; Sænk lynhurtigt Z de 5 mm ned i arbejdshøjde igen
G90                             ; Absolut positionering
