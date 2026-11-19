# MMX Unit in VHDL

Structural VHDL implementation of an **MMX (MultiMedia eXtension) execution unit** — packed SIMD integer operations on 64-bit operands, in the style of Intel's MMX instruction set. University project for *Structura Sistemelor de Calcul* (Technical University of Cluj-Napoca), built and simulated in Xilinx Vivado.

> 🚧 **Work in progress** — see [Status](#status).

## Architecture

| Unit | Description |
|------|-------------|
| **ADD unit** (`src/add_unit`) | 64-bit adder made of 8 × 8-bit adders cascaded ripple-carry; each 8-bit adder is 2 × 4-bit carry-lookahead adders (CLA) linked with lookahead logic. A `pass` control vector breaks the carry chain between bytes, so the same hardware handles packed bytes, words, doublewords and quadwords. |
| **MUL unit** (`src/mul_unit`) | 4 × 16-bit sequential shift-and-add multipliers driven by a control unit (`MUL_CU`). Implements `PMULLW` / `PMULHW` (low / high 16 bits of the 32-bit products). Signed operands handled via sign-magnitude: multiply absolute values, negate the result if signs differ. |
| **LOG unit** (`src/log_unit`) | 64-bit bitwise logic operations (`PAND`, `PANDN`, `POR`, `PXOR`). |
| **Shift unit** | Planned — packed logical/arithmetic shifts. |

Block diagrams are in [`docs/scheme`](docs/scheme); full design documentation (in Romanian) is in [`docs/documentatie.pdf`](docs/documentatie.pdf).

## Repository layout

```
src/   synthesizable VHDL sources, one folder per unit
sim/   testbenches (+ Vivado waveform configs)
docs/  documentation and block diagrams
```

## Simulation

1. Create a Vivado project and add `src/<unit>/*.vhd` as design sources.
2. Add `sim/<unit>/*_tb.vhd` as simulation sources, set the desired testbench as top.
3. Run **Behavioral Simulation**.

## Status

- [x] ADD unit (4-bit CLA → 8-bit → 64-bit packed adder) + testbenches
- [x] MUL unit (`PMULLW`, `PMULHW`) + testbenches
- [x] LOG unit + testbench
- [ ] Shift unit
- [ ] Saturation logic
- [ ] Top-level integration and full-system testbench
