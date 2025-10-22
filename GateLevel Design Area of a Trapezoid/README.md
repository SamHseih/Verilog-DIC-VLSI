# Verilog Structural-Level Design

## Description

This lab implements a **structural-level Verilog circuit** that calculates the **area of a trapezoid** using **standard cells** only.
The system integrates three fundamental arithmetic blocks:

1. **Adder** — Computes $(a + b)$
2. **Unsigned Multiplier** — Multiplies $(a + b) \times c$
3. **Shifter** — Divides the result by 2 through right shifting

The objective is to design, simulate, and verify the entire system **without using any behavioral Verilog constructs**.
All logic must be composed of **standard cell instances** provided by the `umc18_neg.v` library.

---

## Formula

[
\text{Area} = \frac{(a + b) \times c}{2}
]

where:

* `a` : upper base length
* `b` : lower base length
* `c` : trapezoid height

---

## I/O Port Definition

| Signal | Direction | Width  | Description               |
| :----- | :-------- | :----- | :------------------------ |
| `a`    | Input     | [7:0]  | Upper base                |
| `b`    | Input     | [7:0]  | Lower base                |
| `c`    | Input     | [7:0]  | Height                    |
| `out`  | Output    | [15:0] | Calculated trapezoid area |

---

## Design Notes

* No behavioral constructs (`always`, `assign`, `+`, `*`) allowed
* Each logic operation must be built using **cell instances**
* Follow **signal naming conventions** for clarity
* Validate bit-width consistency between stages

---

## Example Structural Snippet

```verilog
module lab03b(a, b, c, out);
  input [7:0] a, b, c;
  output [15:0] out;

  wire [7:0] sum;
  wire [15:0] product;
  wire carry;

  // (a + b)
  ADDHX4 add1(sum[0], carry, a[0], b[0]);
  // ... remaining adder stages

  // (a + b) * c
  AND2X4 and1(product[0], sum[0], c[0]);
  // ... partial products & adders

  // shift right by 1 (divide by 2)
  assign out = product >> 1;
endmodule
```

