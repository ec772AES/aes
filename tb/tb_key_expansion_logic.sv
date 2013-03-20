`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic load_enable;
	logic [127:0] key_in, key_out;
	logic [31:0] rcon_in;

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

	initial begin
	  load_enable = 0;
		key_in = 0;
		rcon_in = 0;
		#10 load_enable = 1;
	end

always @ (posedge clk)
begin
  key_in = key_in+1;
	rcon_in = rcon_in+1;
end

	//instantiate dut
  key_expansion_logic dut(clk, rst, load_enable, key_in, rcon_in, key_out);
	endmodule
