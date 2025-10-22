# Verilog Project Collection (VLSI/DIC course)

## Overview
This repository collects Verilog-based hardware design labs and projects from **CSIE Digital IC Design (DIC)** and **VLSI Lab** courses.  

---

## Common Tools
- **OS**:Linux
- **Waveform Viewer:** nWave
- **Editor:** vim/gvim
- **RTL Simulation:** Cadence NC-Verilog 
- **Synthesis/Netlist Generation:** Cadence Genus
- **APR:** Cadence Innovus
- **Verification(DRC、LVS、LPE):** Calibre  

---

## Lab List and Summaries

### Area of a Trapezoid — Gate-Level Design
**Description:** Implements a structural-level Verilog design using only standard cells to compute the area of a trapezoid (no behavioral constructs).

The design integrates three fundamental arithmetic blocks:
1. **Adder** – computes $(a + b)$  
2. **Unsigned Multiplier** – computes $(a + b) \times c$  
3. **Shifter** – divides by 2 using a right shift

---

### Multi-Bank Filter (MBF) — RTL & Synthesis
**Description**: Designs a digital signal processing circuit implementing a **Multi-Bank Filter** that simultaneously processes input data through both high-pass (HPF) and low-pass (LPF) paths.

- Input: 13-bit fixed-point data (9-bit integer + 4-bit fractional)  
- Output: Two 13-bit filtered signals (`X_DATA` for HPF, `Y_DATA` for LPF)  
- Must operate within **5 ns clock period** and **latency < 5 cycles**  

---

### Find Shortest Path in 5×5 Matrix — RTL
**Description:** Implements a behavioral-level Verilog algorithm to build a GPS-like shortest path circuit that finds the minimal path from f(0,0) to f(4,4).

- Input: 23 distance values (map weights)  
- Output: 8 path points `(Xi, Yi, SUMi)`  
- Movement: **only right and up**  
- Latency < 50 cycles  

---

### Square Root Circuit — RTL & Synthesis
**Description:** Designs a behavioral-level fixed-point arithmetic circuit that computes the square root (√x) of a 16-bit unsigned input.

- Output: 12-bit fixed-point value (8-bit integer + 4-bit fraction)  
- Latency ≤ 20 cycles  
- No ChipWare or DesignWare components allowed  
- Verified at both RTL and gate-level  

---

### Intersection of Two Circles — RTL & Synthesis
**Description:** Designs a Verilog hardware module that computes the number of integer grid points within the intersection of two circles on an 8×8 plane.

- Input: Two circle centers and radii  
- Output: Count of intersecting integer points  
- Requires low-power synthesis and timing ≤ 10 ns  

---

### DIC Final Project – Floating-Point Multiplier — RTL, Synthesis, APR & Post-Layout
**Description:** Implements a pipelined floating-point multiplier compliant with the IEEE 754 double-precision arithmetic standard.

- Input: Two 64-bit double-precision operands  
- Output: 64-bit result  
- Must operate at **150 MHz** with latency < 60 cycles  
- Rounding mode: *Round to nearest*  
- Evaluated through RTL, gate-level, APR, and DRC/LVS verification  

