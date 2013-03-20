`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic [127:0]  din, dout;

always @(clk)
  #10 clk = ~clk;

	initial
	begin
	  rst = 1;
		clk = 1;
	  #100
		din = 123456789;
		#200
		$stop;
	end

	//instantiate dut
	sub_bytes dut(clk, din, dout);

	endmodule
