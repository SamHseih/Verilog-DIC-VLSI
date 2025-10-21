# Multi-Bank Filter (MBF)

## Description
This lab designs a **Multi-Bank Filter (MBF)** circuit that processes an input signal through two separate filters:
- **High-Pass Filter (HPF)**
- **Low-Pass Filter (LPF)**  

Both filters use predefined impulse response coefficients and operate on fixed-point data.  
The circuit must produce both HPF and LPF outputs with correct timing and latency.

---

### I/O Port Definition
| Signal | Dir | Width | Description |
|---------|-----|--------|--------------|
| `CLK` | in | 1 | Clock signal |
| `RESET` | in | 1 | Asynchronous reset (active-high) |
| `IN_VALID` | in | 1 | Input valid signal |
| `IN_DATA` | in | 13 | Input data (9-bit integer + 4-bit fractional) |
| `OUT_VALID` | out | 1 | Output valid signal |
| `X_DATA` | out | 13 | HPF output data |
| `Y_DATA` | out | 13 | LPF output data |

---

## Operation
1. When `IN_VALID` = 1, input data are accepted.
2. Filter the input signal with both HPF and LPF simultaneously.
3. When output is ready, `OUT_VALID` = 1, and both `X_DATA` and `Y_DATA` are output.
4. After completion, `OUT_VALID` is pulled low, and the system can process the next input set.

---

## Timing & Constraints
- **Latency:** less than 5 clock cycles  
- **Clock period:** 5 ns  
- **All inputs** are synchronized with the rising edge of the clock.  
- **Reset:** active-high asynchronous  