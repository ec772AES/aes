`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic [127:0] rkey, din, dout;
	logic [3:0] addr;

always @(clk)
  #10 clk = ~clk;

	initial
	begin
	  rst = 1;
		clk = 1;
	  #100
		rst = 0;
		#200
		$stop;
	end

	//instantiate dut
	enc_pipeline dut(clk, rst, rkey, addr, din, dout);

	endmodule
