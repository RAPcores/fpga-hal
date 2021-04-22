
module pll #(
    parameter f_pllin =   16000000,
    parameter f_pllout = 100000000,
    parameter simple_feedback = 1,
    parameter arch = "ice40"
) (
    input wire pllin,
    output wire pllout,
    output wire locked
    //output wire found_something_w
);


    localparam divf_max = simple_feedback ? 127 : 63;

    if (arch == "ice40") begin
        function [129:0] ice40_pll_comp;
            input integer f_pllin;
            input integer f_pllout;
            input simple_feedback;
            input integer best_fout = 0;
            input integer best_divr = 0;
            input integer best_divf = 0;
            input integer best_divq = 0;
            input integer found_something = 0;
            input integer f_pfd = 0;
            input integer f_vco = 0;
            input integer fout = 0;
            input integer choice_err = 0;
            input integer best_err = 0;
            input integer divr = 0;
            input integer divf = 0;
            input integer divq = 0;

            // The documentation in the iCE40 PLL Usage Guide incorrectly lists the
            // maximum value of DIVF as 63, when it is only limited to 63 when using
            // feedback modes other that SIMPLE.

            //if (f_pllin < 10 || f_pllin > 133) begin
            //	$display("Error: PLL input frequency MHz is outside range 10 MHz - 133 MHz!\n");
            //end

            //if (f_pllout < 16 || f_pllout > 275) begin
            //	$display("Error: PLL output frequency MHz is outside range 16 MHz - 275 MHz!\n");
            //end
            for(divr = 0; divr < 16; divr=divr+1) begin
                f_pfd = (f_pllin / (divr + 1));
                if (!(f_pfd < 10*1e6 || f_pfd > 133*1e6)) for (divf = 0; divf <= divf_max; divf=divf+1) begin
                    if (simple_feedback) begin

                        f_vco = f_pfd * (divf + 1);
                        if (!(f_vco < 533*1e6 || f_vco > 1066*1e6)) for (divq = 1; divq <= 6; divq=divq+1) begin
                            fout = (f_pfd * (divf + 1)) >> divq;

                            choice_err = fout > f_pllout ? fout - f_pllout : f_pllout - fout;
                            best_err = best_fout > f_pllout ? best_fout - f_pllout : f_pllout - best_fout;
                            if (choice_err < best_err || !found_something) begin
                                ice40_pll_comp[31:0] = fout;
                                ice40_pll_comp[63:32] = divr;
                                ice40_pll_comp[95:64] = divf;
                                ice40_pll_comp[128:96] = divq;
                                ice40_pll_comp[129] = 1;
                            end
                        end
                    end /*else begin
                        for (divq = 1; divq <= 6; divq=divq+1) begin
                            localparam real f_vco = f_pfd * (divf + 1) * exp2(divq);
                            if (!(f_vco < 533 || f_vco > 1066)) begin 

                                localparam real fout = f_vco * exp2(-divq);

                                if (fabs(fout - f_pllout) < $abs(best_fout - f_pllout) || !found_something) begin
                                    localparam real best_fout = fout;
                                    localparam real best_divr = divr;
                                    localparam real best_divf = divf;
                                    localparam real best_divq = divq;
                                    localparam found_something = 1;
                                end
                            end
                        end
                    end*/
                end
            end
        endfunction

    localparam ice40_result = ice40_pll_comp(f_pllin, f_pllout, simple_feedback);

    initial begin
        $display(ice40_result);
    end

    end

endmodule

