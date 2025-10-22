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
- - **Verification(DRC、LVS、LPE):** Calibre  

---

## Lab List and Summaries

### Area of a Trapezoid — Gate-Level Design
**Topic:** Structural-level digital design using standard cells  
**Goal:**  
Implement a **gate-level Verilog circuit** that computes the area of a trapezoid using **only standard cells** (no behavioral constructs).  
The design integrates three fundamental arithmetic blocks:
1. **Adder** – computes $(a + b)$  
2. **Unsigned Multiplier** – computes $(a + b) \times c$  
3. **Shifter** – divides by 2 using a right shift

---

### Multi-Bank Filter (MBF) — RTL & Synthesis
**Topic:** Digital signal processing – High-Pass and Low-Pass Filters  
**Goal:**  
Design a **Multi-Bank Filter** that processes input data through both HPF and LPF paths simultaneously.  
- Input: 13-bit fixed-point data (9-bit integer + 4-bit fractional)  
- Output: Two 13-bit filtered signals (`X_DATA` for HPF, `Y_DATA` for LPF)  
- Must operate within **5 ns clock period** and **latency < 5 cycles**  

---

### Find Shortest Path in 5×5 Matrix — RTL
**Topic:** Behavioral-level algorithm implementation in Verilog  
**Goal:**  
Build a **GPS-like shortest path circuit** that finds the minimal path from **f(0,0)** to **f(4,4)**.  
- Input: 23 distance values (map weights)  
- Output: 8 path points `(Xi, Yi, SUMi)`  
- Movement: **only right and up**  
- Latency < 50 cycles  

---

### Square Root Circuit — RTL & Synthesis
**Topic:** Behavioral logic synthesis – Fixed-point arithmetic  
**Goal:**  
Design a **square root circuit** that computes the √x of a 16-bit unsigned input.  
- Output: 12-bit fixed-point value (8-bit integer + 4-bit fraction)  
- Latency ≤ 20 cycles  
- No ChipWare or DesignWare components allowed  
- Verified at both RTL and gate-level  

---

### Intersection of Two Circles — RTL & Synthesis
**Topic:** Geometric computation in hardware  
**Goal:**  
Design a Verilog module `SET.v` to calculate the number of integer points within the intersection of two circles on an 8×8 grid.  
- Input: Two circle centers and radii  
- Output: Count of intersecting integer points  
- Requires low-power synthesis and timing ≤ 10 ns  

---

### DIC Final Project – Floating-Point Multiplier — RTL, Synthesis, APR & Post-Layout
**Topic:** IEEE 754 double-precision floating-point arithmetic  
**Goal:**  
Implement a **pipelined floating-point multiplier** compliant with IEEE 754 standard.  
- Input: Two 64-bit double-precision operands  
- Output: 64-bit result  
- Must operate at **150 MHz** with latency < 60 cycles  
- Rounding mode: *Round to nearest*  
- Evaluated through RTL, gate-level, APR, and DRC/LVS verification  

