`timescale 1ns/10ps

module fir_filter_autocheck_tb;
    parameter width = 8;

    logic clk;
   
    logic [width-1:0] fir_in;
    logic [width-1:0] w_1;
    logic [width-1:0] w_2;
    logic [width-1:0] w_3;
    logic [2*width-1:0] fir_out;
    logic dut_error;
    logic [71:0] input_data;
   
    integer i,j,k;
    
    fir_filter I1(
    .fir_in(fir_in),
    .clk(clk),
    .w_1(w_1),
    .w_2(w_2),
    .w_3(w_3),
    .fir_out(fir_out)
    );

    event terminate_sim;
   

`ifdef DUMP_WAVES
   initial
     begin
        $dumpvars;
        $dumpall;
        $dumpfile("waves.shm");
        $stop;
     end
`endif
   
   initial
     begin
        clk = 0;
        forever
          #1 clk = ~clk;
     end

`include "stim.v"
   
endmodule
