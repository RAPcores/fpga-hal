module pll_tb();




pll #(.arch("ice40")) pll0 ();

initial begin
    assert(pll0.f_pllin);
    //$display(pll0.f_pllout);
    //$display(pll0.arch);
end

endmodule