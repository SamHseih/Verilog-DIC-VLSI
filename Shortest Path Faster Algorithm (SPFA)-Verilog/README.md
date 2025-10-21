# Find Shortest Path in 5×5 Matrix

## Description
This lab designs a simple **GPS guiding circuit** that finds the **shortest path** from the start point to the destination point in a 5×5 grid map.

Each input map provides distance values between neighboring points.  
The circuit must determine the shortest route from **f(0,0)** to **f(4,4)**, moving **only right or up** at each step, and output the total accumulated distance for each point along the shortest path.

---

## I/O Port Definition
| Signal | Dir | Width | Description |
|---------|-----|--------|--------------|
| `CLK` | in | 1 | Clock signal |
| `RESET` | in | 1 | Synchronous reset (active-high) |
| `IN_VALID` | in | 1 | Input valid signal |
| `IN_DATA` | in | 8 | Input distance data (unsigned) |
| `OUT_VALID` | out | 1 | Output valid signal |
| `OUT_DATA_X` | out | 4 | X coordinate of path point |
| `OUT_DATA_Y` | out | 4 | Y coordinate of path point |
| `OUT_DATA_SUM` | out | 16 | Cumulative distance at this point |

---

## Operation
- Input: 23 distance data values per map (f(0,0)=0 and f(4,4)=0 are fixed).  
- Movement allowed: **right** and **up** only.
- Output: 8 points along the shortest path in the form `(Xi, Yi, SUMi)`.
- Output timing:
  - `OUT_VALID` = 1 → output valid data
  - Output 8 sets (one per clock cycle)

---

## Example
For one map input, the correct output is:

```
(1, 0, 19)
(2, 0, 47)
(2, 1, 108)
(2, 2, 164)
(3, 2, 210)
(3, 3, 223)
(3, 4, 322)
(4, 4, 322)
```

---

## Timing & Constraints
- **All signals** synchronized to rising edge of `CLK`.
- **Synchronous reset** (active-high).
- Latency: must be **less than 50 cycles** after last input.

---
