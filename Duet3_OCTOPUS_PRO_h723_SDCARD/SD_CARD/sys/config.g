; ==============================================================================
; Configuration file for BTT Octopus Pro V1.1 (H723)
; Optimeret til ZhengBang ZB3245TSS OpenPnP Setup
; ==============================================================================

; --- 1. Generelle præferencer & Buffer optimering ---
G90                                                  ; Absolutte koordinater
M550 P"ZB3245TSS"                                    ; Maskinens navn på netværket
M575 P0 B0                                           ; Sæt native USB-port til rå G-kode-tilstand
M595 P60 R60                                         ; UDVIDET BUFFER: Giver plads til 60 asynkrone bevægelser i køen (Perfekt til OpenPnP)

; --- 2. Netværk (Wi-Fi) ---
M552 S1                                              ; Aktiver netværkskortet (Klient-tilstand)
M586 P0 S1                                           ; Aktiver HTTP (Duet Web Control)
M586 P1 S0                                           ; Deaktiver FTP
M586 P2 S0                                           ; Deaktiver Telnet

; --- 3. Driver-opsætning (Drives) ---
M569 P0 S1 T2.5:2.5:5:5                              ; Driver 0 (X)
M569 P1 S0 T2.5:2.5:5:5                              ; Driver 1 (Y)
M569 P2 S1 T2.5:2.5:5:5                              ; Driver 2 (Z)
M569 P3 S1 T2.5:2.5:5:5                              ; Driver 3 (U - Nozzle I Rotation)
M569 P4 S1 T2.5:2.5:5:5                              ; Driver 4 (V - Nozzle J Rotation)
M569 P5 S1 T2.5:2.5:5:5                              ; Driver 5 (W - Tape K Cover Film)
M569 P6 S1 T2.5:2.5:5:5                              ; Driver 6 (A - Tape U Cover Film)
M569 P7 S1 T2.5:2.5:5:5                              ; Driver 7 (B - Reserve V)

; --- 4. Akse-mapping ---
M584 X0 Y1 Z2 U3 V4 W5 A6 B7 R3:4:5:6

; --- 5. Microstepping & Trin-konfiguration (Steps) ---
M350 X32 Y32 Z16 U32 V32 W16 A32 B16 I1               ; Microstepping med interpolation
M92 X80.00 Y80.00 Z400.00 U17.78 V17.78 W8.8889 A8.8889 B400.00

; --- 6. Hastigheder, Accelerationer & Jerk ---
M566 X1200 Y1200 Z100 U1800 V1800 W1800 A1800 B100   ; Maks ryk (mm/min eller grader/min)
M203 X30000 Y30000 Z2000 U36000 V36000 W36000 A36000 B2000 ; Maks hastighed (mm/min eller grader/min)
M201 X3000 Y3000 Z500 U5000 V5000 W3000 A3000 B500   ; Acceleration (mm/s² eller grader/s²)
M906 X800 Y800 Z800 U800 V800 W800 A800 B800 I30     ; Motorstrøm hold-factor (Ignoreres ved dumme drivere)

; --- 7. Aksegrænser ---
M208 X0 Y0 Z0 U0 V0 W0 A0 B0 S1                       ; Minimum
M208 X420 Y520 Z100 U360 V360 W360 A360 B100 S0       ; Maksimum

; --- 8. Endstops ---
M574 X1 S1 P"^!pg6"                                  ; X-endstop på PG6
M574 Y1 S1 P"^!pg9"                                  ; Y-endstop på PG9
M574 Z1 S1 P"pg10"                                   ; Z-endstop på PG10

; --- 9. Deaktivering af 3D-printer Sikkerhedssystemer ---
M999 S1                                              ; Ignorer manglende varmelegemer ved boot
M562 H0:1:2                                          ; Nulstil og deaktiver heater-fejl for altid

; --- 10. OpenPnP I/O (Ventiler, Pumper og Lys) ---
M950 P0 C"!pa8" F500                                 ; P0: Over-kamera Lys
M950 P1 C"!pe5" F500                                 ; P1: Under-kamera Lys
M950 P2 C"pa1" F500                                  ; P2: Vakuum Pumpe
M950 P3 C"pa2" F500                                  ; P3: Vakuum Ventil 1
M950 P4 C"pa3" F500                                  ; P4: Vakuum Ventil 2
M950 P5 C"pb10" F500                                 ; P5: Blow-off
M950 P6 C"pb11" F500                                 ; P6: Drag Pin Actuator

; --- 11. Sikkerhedsknap / Triggere ---
M950 J0 C"^!pg11"                                    ; Opret indgang J0 på PG11
M581 T2 P0 S1 R0                                     ; Kobl J0 til Trigger 2

; --- 12. Afslutning ---
M117 ZB3245TSS Klar!                                 ; Statusbesked i Duet Web Control

