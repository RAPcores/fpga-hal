# FPGA-HAL

Experimental HAL.

Right now seeing if we can determine PLL parameters
using pure verilog. This should eliminate `icepll` and `ecppll`
as build-time code generators. (promising ATM)

Verilog has a rich system for inlining and eliding expressions.
The hypothesis here is we can use this to simplify build steps
and provide common interfaces amongst FPGA, sim, and ASIC.
