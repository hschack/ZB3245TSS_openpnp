# VacSensor - ZB3245TSS OpenPnP Upgrade

![Project Banner](./billede.png)

> **Eliminating "Malware-ware":** A high-performance, open-source vacuum sensing node designed for precision Pick-and-Place operations.

This repository contains the hardware and firmware for upgrading the **ZB3245TSS** (7-axis) Pick-and-Place machine to **OpenPnP**. This module specifically replaces the proprietary, closed-source factory vacuum controllers with a transparent, stable, and fast G-code based solution.

---

## 📍 Project Version: VacSensor Only (v1.1)

This version is a streamlined, "clean" PCB design focused 100% on reliable dual-nozzle vacuum sensing. It is designed for users who want a dedicated, standalone vacuum node that is easy to install and "malware-free".

### Key Features
* **MCU:** ATtiny3224 (Running a non-blocking C++ state machine at 20MHz).
* **Sensors:** 2 x **XGZP6847A** Analog Pressure Sensors.
* **Connectivity:** Dedicated **USART-to-USB (FTDI-style)** interface. Recognized as a standard COM port by OpenPnP for "Plug & Play" integration.
* **Digital Filtering:** Exponential Moving Average (EMA) filtering for rock-solid values without sacrificing response speed.

---

## 📂 Repository Structure

* 📂 **[Code](./Code):** * `Source/`: Optimized C++ source code (0% `delay()`).
    * `Firmware/`: Pre-compiled `.bin`/`.hex` files for quick deployment.
* 📂 **[KiCad](./KiCad):** Professional PCB designs for the ATtiny3224 node and level-shifter adapters.
* 📂 **[Images](./Images):** Photos of the assembled boards and installation inside the ZB3245TSS.
* 📂 **[BOM](./BOM):** Detailed Bill of Materials and component datasheets.

---

## ⌨️ G-Code Interface

The node communicates at **115200 Baud (8N1)**.

| Command | Action |
| :--- | :--- |
| **M115** | Firmware identification and repository link. |
| **M800** / **M105** | Poll sensors. Returns `ok AVAC1:X AVAC2:Y` |
| **M802** | Zero/Tare sensors (Stored in RAM for current session). |
| **M500** | Save current zero-points permanently to EEPROM. |
| **M501** | Load zero-points from EEPROM (Automatic on boot). |

### OpenPnP Configuration
Use the following **Regex** in your Actuator settings to read the values:
`^ok.*AVAC1:(?<Value>-?\d+)` and `^ok.*AVAC2:(?<Value>-?\d+)`

---

## 🚀 Roadmap: Moving to v2.0

While the **VacSensor Only** version focuses on vacuum reliability, a **v2.0** is currently in development for the full 7-axis overhaul.

* **Integrated 3-Axis Accelerometer:** **LIS3DH** connected via a dedicated **SPI interface**.
* **Head Resonance Analysis:** Direct integration with the **SpiderV3 H723** main controller for Input Shaping and vibration analysis.

**Follow the v2.0 development here:** 🔗 [https://github.com/hschack/ZB3245TSS_OPENPNP/tree/main/VacSensor](https://github.com/hschack/ZB3245TSS_OPENPNP/tree/main/VacSensor)

---

*Part of the ZB3245TSS OpenPnP Upgrade Suite. Developed by hschack.*