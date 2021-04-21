/*
bool analyze(
		bool simple_feedback, double f_pllin, double f_pllout,
		double *best_fout, int *best_divr, int *best_divf, int *best_divq
		) 
{
*/
module pll #(
    parameter f_pllin = 16,
    parameter f_pllout = 100,
    parameter simple_feedback = 1,
) (
    input wire pllin,
    output wire pllout,
    output wire locked
);

	localparam integer found_something = 0;
	localparam real best_fout = 0.0;
	reg [31:0] best_divr = 0;
	reg [31:0] best_divf = 0;
	reg [31:0] best_divq = 0;
    localparam real f_pfd = 0.0;
    localparam real f_vco = 0.0;
    localparam real fout = 0.0;
    genvar divr = 0;

	integer divf_max = simple_feedback ? 127 : 63;
	// The documentation in the iCE40 PLL Usage Guide incorrectly lists the
	// maximum value of DIVF as 63, when it is only limited to 63 when using
	// feedback modes other that SIMPLE.

	//if (f_pllin < 10 || f_pllin > 133) begin
	//	$display("Error: PLL input frequency MHz is outside range 10 MHz - 133 MHz!\n");
    //end

	//if (f_pllout < 16 || f_pllout > 275) begin
	//	$display("Error: PLL output frequency MHz is outside range 16 MHz - 275 MHz!\n");
    //end

    specify
        for(divr = 0; divr < 16; divr=divr+1) begin
            specparam f_pfd = f_pllin / (divr + 1);
            if (!(f_pfd < 10 || f_pfd > 133))
            for (divf = 0; divf <= divf_max; divf=divf+1) begin
                if (simple_feedback) begin
                    specparam f_vco = f_pfd * (divf + 1);
                    if (!(f_vco < 533 || f_vco > 1066))
                    for (divq = 1; divq <= 6; divq++) begin
                        specparam fout = f_vco * exp2(-divq);

                        if (fabs(fout - f_pllout) < fabs(best_fout - f_pllout) || !found_something) begin
                            specparam best_fout = fout;
                            specparam best_divr = divr;
                            specparam best_divf = divf;
                            specparam best_divq = divq;
                            specparam found_something = 1;
                        end
                    end
                end else begin
                    for (divq = 1; divq <= 6; divq++) begin
                        assign f_vco = f_pfd * (divf + 1) * exp2(divq);
                        if (!(f_vco < 533 || f_vco > 1066)) begin 

                            assign fout = f_vco * exp2(-divq);

                            if (fabs(fout - f_pllout) < fabs(best_fout - f_pllout) || !found_something) begin
                                assign best_fout = fout;
                                assign best_divr = divr;
                                assign best_divf = divf;
                                assign best_divq = divq;
                                assign found_something = 1;
                            end
                        end
                    end
                end
            end
        end
    endspecify

endmodule