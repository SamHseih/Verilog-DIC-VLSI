# Final Project – Floating Point Number Multiplier

## Description
This project implements a **pipelined floating-point multiplier** based on the **IEEE 754 double-precision** (64-bit) format.  
The goal is to design, verify, and synthesize a high-performance and fully compliant floating-point multiplier.

---

## Specifications
- **IEEE 754 Double-Precision Format**
  - 1 sign bit
  - 11 exponent bits (bias = 1023)
  - 52 fraction bits
- **Rounding mode:** Round to nearest
- **Clock frequency:** 150 MHz
- **Maximum latency:** ≤ 60 clock cycles
- **Active-high synchronous reset**

---

## I/O Ports
| Signal | Dir | Width | Description |
|---------|-----|--------|--------------|
| `CLK` | in | 1 | Clock |
| `RESET` | in | 1 | Synchronous reset (active-high) |
| `ENABLE` | in | 1 | Data input enable |
| `DATA_IN` | in | 8 | Input data bus |
| `DATA_OUT` | out | 8 | Output data bus |
| `READY` | out | 1 | Output valid signal |

---

## Operation
- Input two 64-bit floating-point numbers (`A[63:0]`, `B[63:0]`) via `DATA_IN` when `ENABLE` = 1.  
  Each number is input in **8-bit chunks**, lower bytes first.  
  → 16 cycles are needed for both inputs.
- The result `Z[63:0]` is output through `DATA_OUT` in **8 cycles**, lower bytes first, when `READY` = 1.
- The system must meet **timing at 150 MHz** without violations.