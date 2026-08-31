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
3. SCLK Edge Detection

The design detects:

Rising Edge  : 0 → 1
Falling Edge : 1 → 0

The correct edge for sampling and shifting is selected according to CPOL and CPHA.

4. Data Reception

Data received from MOSI is shifted into the RX shift register.

MOSI
 ↓
RX Shift Register
 ↓
rx_data

After 8 bits are received, rx_valid is asserted.

5. Data Transmission

The transmit data is loaded into the TX shift register and shifted out through MISO.

tx_data
 ↓
TX Shift Register
 ↓
MISO

Data is transferred MSB first.

SPI Modes
Mode	CPOL	CPHA	Clock Idle
0	0	0	LOW
1	0	1	LOW
2	1	0	HIGH
3	1	1	HIGH
Project Structure
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
Verification

We created separate Verilog testbenches for all four SPI modes.

Each testbench generates:

System clock
Reset
Chip Select
SPI clock
MOSI data
CPOL
CPHA
TX data

The output signals such as MISO, rx_data and rx_valid are observed during simulation.

The testbenches also generate a VCD waveform for waveform analysis.

Tools Used
Verilog HDL – RTL Design
Icarus Verilog – Simulation
EDA Playground – Online simulation
EPWave – Waveform analysis
GitHub – Project repository
Outcome

An 8-bit SPI Slave RTL design was developed and tested for SPI Modes 0, 1, 2 and 3, demonstrating SPI signal synchronization, clock-edge detection, serial data transfer, shift registers, and functional verification.
<img width="1840" height="1012" alt="Screenshot 2026-08-31 235019" src="https://github.com/user-attachments/assets/ff4f1ebe-33b2-4275-9907-e8ab79812ecc" />

