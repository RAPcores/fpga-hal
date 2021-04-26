# FPGA-HAL

FPGA Hardware Abstraction Library in Verilog.

Goals:

- Avoid external build steps and code generators.
- Make use of parameters and constant functions for configuration.
- Only use Verilog.
- No macros.

## Support Matrix

|          | ice40 | ecp5 |
|----------|-------|------|
| PLL      |  No   | No   |
| I2C      |  No   | No   |
| SPI      |  No   | No   |
|Oscillator|  No   | No   |

## Use

Releases: https://github.com/RAPcores/fpga-hal/releases


## Modules

### pll

Definition:

```
module pll #(
    parameter f_pllin =   16000000,
    parameter f_pllout = 100000000,
    parameter simple_feedback = 1,
    parameter arch = "ice40"
) (
    input wire pllin,
    input wire resetn,
    output wire pllout,
    output wire locked
);
```

#### Parameters:
`f_pllin` (integer literal) : clock input frequency in hertz
`f_pllout` (integer literal) : clock output frequency in hertz



## Releases

Follow https://semver.org/

## License

ISC License
