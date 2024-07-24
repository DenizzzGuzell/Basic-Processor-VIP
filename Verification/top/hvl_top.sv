module hvl_top;

    import uvm_pkg::*;
    import util_pkg::*;
    `include "timescale.sv"

    initial begin
        $timeformat(-9,3,"ns",5);
        uvm_reg::include_coverage("*", UVM_CVR_ALL);
        run_test();
        #100ns;
    end
endmodule