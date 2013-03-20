`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic [127:0] rkey, din, dout;
	logic [3:0] addr;

always begin
  #1 clk = ~clk;
end

	initial
	begin
	  rst = 1;
		clk = 1;
	  #100
		rst = 0;
		#2000
		$stop;
	end

	initial
	begin
	  rkey = 0;
		addr = 0;
		din = 0;
	end

	always @(posedge clk)
	begin
	  rkey = rkey + 1;
		addr = addr + 1;
		din = din + 1;
	end

	//instantiate dut
	enc_round dut(clk, rst, rkey, addr, din, dout);

	endmodule
