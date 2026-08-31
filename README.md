# RTL Design of SPI Slave in Verilog HDL

## Overview

This project implements an **8-bit SPI Slave using Verilog HDL** at the RTL level.

The SPI Slave supports all four standard SPI modes:

- Mode 0 → CPOL = 0, CPHA = 0
- Mode 1 → CPOL = 0, CPHA = 1
- Mode 2 → CPOL = 1, CPHA = 0
- Mode 3 → CPOL = 1, CPHA = 1

The design supports **MSB-first, full-duplex SPI communication** using MOSI and MISO.

---

## What We Made

We designed an SPI Slave module that:

- Receives serial data through **MOSI**
- Transmits serial data through **MISO**
- Uses **CPOL and CPHA** to select the SPI mode
- Synchronizes external **SCLK, CS and MOSI** signals
- Detects rising and falling edges of SCLK
- Uses **RX and TX shift registers** for data transfer
- Uses a **bit counter** to count the received bits
- Generates `rx_valid` when an 8-bit data word is received

---

## How It Works

### 1. SPI Transaction Starts

The SPI master pulls `CS` LOW.

The slave detects this transition and:

- Captures CPOL and CPHA
- Clears the RX shift register
- Loads `tx_data` into the TX shift register
- Resets the bit counter

### 2. Synchronization

Since `SCLK`, `CS`, and `MOSI` are external signals, they are synchronized with the internal `clk`.


SCLK → Synchronization → Edge Detection
CS   → Synchronization
MOSI → Synchronization
### 3. SCLK Edge Detection

The design detects:

Rising Edge  : 0 → 1
Falling Edge : 1 → 0

The correct edge for sampling and shifting is selected according to CPOL and CPHA.

### 4. Data Reception

Data received from MOSI is shifted into the RX shift register.

MOSI
 ↓
RX Shift Register
 ↓
rx_data

After 8 bits are received, rx_valid is asserted.

### 5. Data Transmission

The `tx_data` is the data that the SPI Slave needs to send to the master.

First, `tx_data` is loaded into the TX shift register. The data is then sent **one bit at a time through MISO**.

tx_data → TX Shift Register → MISO → Master
The data is transmitted MSB first, meaning the most significant bit (D7) is sent first.

## SPI Modes:-

The SPI mode is selected using CPOL and CPHA.

Mode	CPOL	CPHA	SCLK Idle
0	0	0	LOW
1	0	1	LOW
2	1	0	HIGH
3	1	1	HIGH

### 6. Verification

We created four testbenches, one for each SPI mode.

Each testbench:

Generates the system clock and reset.
Sets the required CPOL and CPHA values.
Generates the CS and SPI clock signals.
Sends 8-bit data through MOSI.
Provides tx_data for transmission.
Checks the received and transmitted signals.

The important outputs observed during simulation are:

MISO – transmitted data
rx_data – received 8-bit data
rx_valid – indicates that the complete data has been received

The testbench also generates a VCD waveform to observe the SPI signals during simulation.

### Tools Used
Verilog HDL – RTL design
Icarus Verilog – Simulation
EDA Playground – Online simulation
EPWave – Waveform viewing
GitHub – Source code and documentation

### Project Structure

```text
RTL-Design-of-SPI-Slave-in-Verilog-HDL/
│
├── rtl/
│   └── spi_slave.v
│
├── tb/
│   ├── tb_spi_slave_mode0.v
│   ├── tb_spi_slave_mode1.v
│   ├── tb_spi_slave_mode2.v
│   └── tb_spi_slave_mode3.v
│
└── README.md
```
<img width="1840" height="1012" alt="Screenshot 2026-08-31 235019" src="https://github.com/user-attachments/assets/ff4f1ebe-33b2-4275-9907-e8ab79812ecc" />
<img width="1814" height="914" alt="image" src="https://github.com/user-attachments/assets/cd355293-ae4e-42e7-aace-1c3a49ef5738" />
<img width="1857" height="924" alt="image" src="https://github.com/user-attachments/assets/cf59ca91-5eac-49c6-ab5e-b5f5610cb412" />
<img width="1828" height="925" alt="image" src="https://github.com/user-attachments/assets/6378cfd9-78ce-46d8-9829-ccaad0f9fe5e" />
