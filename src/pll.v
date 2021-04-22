
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

    if (arch == "ice40") begin
        integer best_fout = 0;
        integer best_divr = 0;
        integer best_divf = 0;
        integer best_divq = 0;
        integer found_something = 0;
        integer f_pfd = 0;
        integer f_vco = 0;
        integer fout = 0;
        integer choice_err = 0;
        integer best_err = 0;
        integer divr = 0;
        integer divf = 0;
        integer divq = 0;

        parameter divf_max = simple_feedback ? 127 : 63;
        // The documentation in the iCE40 PLL Usage Guide incorrectly lists the
        // maximum value of DIVF as 63, when it is only limited to 63 when using
        // feedback modes other that SIMPLE.

        //if (f_pllin < 10 || f_pllin > 133) begin
        //	$display("Error: PLL input frequency MHz is outside range 10 MHz - 133 MHz!\n");
        //end

        //if (f_pllout < 16 || f_pllout > 275) begin
        //	$display("Error: PLL output frequency MHz is outside range 16 MHz - 275 MHz!\n");
        //end
        initial for(divr = 0; divr < 16; divr=divr+1) begin
            f_pfd = $rtoi((f_pllin / (divr + 1)));
            $display("f_pfd:%d", f_pfd);
            if (!(f_pfd < 10*1e6 || f_pfd > 133*1e6)) for (divf = 0; divf <= divf_max; divf=divf+1) begin
                if (simple_feedback) begin

                    f_vco = $rtoi(f_pfd * (divf + 1));
                    $display("f_vco:%d", f_vco);
                    if (!(f_vco < 533*1e6 || f_vco > 1066*1e6)) for (divq = 1; divq <= 6; divq=divq+1) begin
                        fout = (f_pfd * (divf + 1)) >> divq;
                        $display("fout:%d", fout);

                        choice_err = fout > f_pllout ? fout - f_pllout : f_pllout - fout;
                        best_err = best_fout > f_pllout ? best_fout - f_pllout : f_pllout - best_fout;
                        if (choice_err < best_err || !found_something) begin
                            best_fout = fout;
                            best_divr = divr;
                            best_divf = divf;
                            best_divq = divq;
                            found_something = 1;
                            $display(best_fout);
                            $display(best_divr);
                            $display(best_divf);
                            $display(best_divq);

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


    end

endmodule

