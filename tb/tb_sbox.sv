`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic [7:0]  din, dout;

always begin
  #1 clk = ~clk;
end

always @(posedge clk) begin
  din = din + 1;
end

	initial
	begin
	  rst = 1;
		clk = 1;
	  #100
		din = 1;
		#2000
		$stop;
	end

	//instantiate dut
	sbox dut(clk, din, dout);

	endmodule
