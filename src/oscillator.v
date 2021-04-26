
module oscillator #(
    parameter freq_out = 1000000,
    parameter arch = "ice40"
)(
    output clockout
);
    if (arch == "ice40") begin
        //internal oscillators seen as modules
        SB_HFOSC SB_HFOSC_inst(
            .CLKHFEN(1),
            .CLKHFPU(1),
            .CLKHF(clk_48mhz)
        );

        //10khz used for low power applications (or sleep mode)
        SB_LFOSC SB_LFOSC_inst(
            .CLKLFEN(1),
            .CLKLFPU(1),
            .CLKLF(clk_10khz)
        );
    end

endmodule