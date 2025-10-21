# Square Root Circuit Design

## Description
This lab designs a **square root circuit** using Verilog at the behavioral level.  
The circuit computes the square root of a **16-bit unsigned integer** input and produces a **12-bit fixed-point** output:
- 8 bits for the integer part  
- 4 bits for the fractional part  

The goal is to design a synthesizable circuit that meets timing and functional requirements without using DesignWare or ChipWare components.

---

## I/O Port Definition

| Signal | Dir | Width | Description |
|---------|-----|--------|--------------|
| `CLK` | in | 1 | Clock signal (rising edge triggered) |
| `RST` | in | 1 | Synchronous reset (active-high) |
| `IN_VALID` | in | 1 | Input valid signal |
| `IN` | in | 16 | Unsigned input number |
| `OUT_VALID` | out | 1 | Output valid signal |
| `OUT` | out | 12 | Output (8-bit integer + 4-bit fraction) |

---

## Operation
- `IN_VALID` asserts for one cycle when input data is valid.  
- When the result is ready, `OUT_VALID` = 1 for one cycle, and the output appears on `OUT`.  
- Output data is only checked when `OUT_VALID` is high.  

---

## Timing & Constraints
- **Clock:** Rising-edge triggered  
- **Reset:** Active-high, synchronous  
- **Latency:** ≤ 20 cycles per input  
- **No ChipWare/DesignWare components allowed**

