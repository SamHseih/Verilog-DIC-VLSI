# Intersection of Two Circles

## Description
This lab designs a circuit that calculates the number of integer coordinate points jointly covered by two circles within an 8×8 coordinate grid.

Each circle is defined by its center `(x, y)` and radius `r`.  
The circuit counts how many integer points are inside **both circles** (the intersection of Set A and Set B).

---
### I/O Ports
| Signal | Dir | Width | Description |
|---------|-----|--------|--------------|
| `rst` | in | 1 | Active-high synchronous reset |
| `clk` | in | 1 | Clock signal |
| `en` | in | 1 | Input valid signal |
| `central` | in | 16 | Circle centers: `[15:12]` x1, `[11:8]` y1, `[7:4]` x2, `[3:0]` y2 |
| `radius` | in | 8 | Circle radii: `[7:4]` r1, `[3:0]` r2 |
| `busy` | out | 1 | Circuit busy indicator |
| `valid` | out | 1 | Output valid indicator |
| `candidate` | out | 8 | Number of intersection points |

---

## Operation
1. When `en` = 1, the circuit starts computation (`busy` = 1).
2. When finished, `busy` = 0 and `valid` = 1.
3. The result (intersection count) appears on `candidate`.

---

## Notes
- Coordinate range: (1,1) to (8,8)
- Use **pipelined multiplier (`CW_mult_n_stage`)** with **3 stages**
- Clock period: **10 ns**
- Include **low-power synthesis** results in your report

---

**Example:**  
For circles (3,3,r=3) and (5,5,r=3), the intersection count = **7**.
