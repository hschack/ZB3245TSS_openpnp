#include <Arduino.h>
#include <EEPROM.h>

/**
 * OpenPnP Vacuum Controller v2.2 - "The Malware Slayer"
 * -----------------------------------------------------------
 * Hardware: ATtiny3224 @ 20MHz
 * Purpose: Dual Vacuum Nozzle Sensing + G-Code Parser
 */

// --- Pin Definitioner --- 
const int pinVac1 = PIN_PA1; // Sensor 1
const int pinVac2 = PIN_PA2; // Sensor 2
const int pinAliveLed = PIN_PB0; // Status LED

// --- Filter & Kalibrering ---
float filterAlpha = 0.15;        
float filteredVac1, filteredVac2;
int offsetVac1, offsetVac2;

// --- EEPROM Mapping ---
const int ADDR_MAGIC = 0;  
const int ADDR_OFF1  = 2;  
const int ADDR_OFF2  = 6;  
const int MAGIC_VAL  = 42; 

// --- Timing & State Machine ---
unsigned long lastSampleMicros = 0;
unsigned long lastLedToggle = 0;
int adcState = 0; 
String inputString = "";

void setup() {
  // Start Serial med det samme. 115200 er standard for moderne PnP.
  Serial.begin(115200);
  
  pinMode(pinVac1, INPUT);
  pinMode(pinVac2, INPUT);
  pinMode(pinAliveLed, OUTPUT);

  // Giv sensorerne tid til at vågne
  delay(150);

  // Indlæs fra EEPROM eller lav en nød-kalibrering
  if (EEPROM.read(ADDR_MAGIC) == MAGIC_VAL) {
    EEPROM.get(ADDR_OFF1, offsetVac1);
    EEPROM.get(ADDR_OFF2, offsetVac2);
    // Vi sender en besked med 'ok' så OpenPnP ved vi er her
    Serial.println("ok Boot: Loaded offsets from EEPROM");
  } else {
    long s1 = 0, s2 = 0;
    for(int i=0; i<32; i++) {
      s1 += analogRead(pinVac1);
      s2 += analogRead(pinVac2);
      delay(1);
    }
    offsetVac1 = s1 / 32;
    offsetVac2 = s2 / 32;
    Serial.println("ok Boot: Factory auto-tare performed");
  }
  
  filteredVac1 = (float)offsetVac1;
  filteredVac2 = (float)offsetVac2;
  
  // Tøm serial buffer for at undgå start-støj
  while(Serial.available() > 0) Serial.read();
}

// --- Async ADC Læsning (Ingen delay!) ---
void updateSensors() {
  unsigned long now = micros();

  switch (adcState) {
    case 0: // Start cyklus hver 1ms
      if (now - lastSampleMicros >= 1000) {
        analogRead(pinVac1); // Skift MUX internt i ATtiny
        lastSampleMicros = now;
        adcState = 1;
      }
      break;

    case 1: // Vent 50us på S1 stabilitet
      if (now - lastSampleMicros >= 50) {
        int raw1 = analogRead(pinVac1);
        filteredVac1 = (filterAlpha * (float)raw1) + (1.0 - filterAlpha) * filteredVac1;
        analogRead(pinVac2); // Skift MUX til S2
        lastSampleMicros = now; 
        adcState = 2;
      }
      break;

    case 2: // Vent 50us på S2 stabilitet
      if (now - lastSampleMicros >= 50) {
        int raw2 = analogRead(pinVac2);
        filteredVac2 = (filterAlpha * (float)raw2) + (1.0 - filterAlpha) * filteredVac2;
        adcState = 0; // Færdig
      }
      break;
  }
}

void loop() {
  updateSensors();

  // Alive LED blink (viser at koden ikke er låst)
  if (millis() - lastLedToggle >= 1000) {
    lastLedToggle = millis();
    digitalWrite(pinAliveLed, !digitalRead(pinAliveLed));
  }

  // --- G-Code Parser ---
  while (Serial.available() > 0) {
    char c = (char)Serial.read();
    
    if (c == '\n' || c == '\r') {
      inputString.trim(); // Vigtigt: fjerner usynlig støj/mellemrum
      
      if (inputString.length() > 0) {
        inputString.toUpperCase();

        // M115 - Identifikation (Gør OpenPnP glad)
        if (inputString.startsWith("M115")) {
          Serial.print("FIRMWARE_NAME:OpenPnP_Vacuum_Node_v0.2 ");
          Serial.print("MACHINE_TYPE:ATtiny3224_Dinkonto ");
          Serial.println("FIRMWARE_URL:https://github.com/dinkonto/");
          Serial.println("ok");
        } 
        
        // M800 / M105 - Send vakuum data
        else if (inputString.startsWith("M800") || inputString.startsWith("M105")) {
          int out1 = constrain(offsetVac1 - (int)filteredVac1, 0, 1024);
          int out2 = constrain(offsetVac2 - (int)filteredVac2, 0, 1024);
          Serial.print("ok AVAC1:"); Serial.print(out1);
          Serial.print(" AVAC2:"); Serial.println(out2);
        } 
        
        // M802 - Nulstil nu (RAM)
        else if (inputString.startsWith("M802")) {
          offsetVac1 = (int)filteredVac1;
          offsetVac2 = (int)filteredVac2;
          Serial.println("ok Sensors Zeroed (RAM)");
        } 
        
        // M500 - Gem til EEPROM
        else if (inputString.startsWith("M500")) {
          EEPROM.update(ADDR_MAGIC, MAGIC_VAL);
          EEPROM.put(ADDR_OFF1, offsetVac1);
          EEPROM.put(ADDR_OFF2, offsetVac2);
          Serial.println("ok Settings Saved to EEPROM");
        }

        // M502 - Reset EEPROM / Factory Tare
        else if (inputString.startsWith("M502")) {
          EEPROM.write(ADDR_MAGIC, 0); // Slet magic byte
          Serial.println("ok EEPROM Reset - Restart to re-tare");
        }
        
        // CATCH-ALL: Svar 'ok' på alt andet (G21, M110, etc.)
        // Dette fjerner "Error on reading from controller" i OpenPnP
        else {
          Serial.println("ok");
        }
        
        inputString = ""; // Klar til næste kommando
      }
    } 
    // Opbyg strengen (kun valide tegn)
    else if (c >= 32 && c <= 126) {
      inputString += c;
    }
  }
}