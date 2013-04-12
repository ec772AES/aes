`timescale 1ns/10ps

module testbench;

  //dut signals
  logic clk;
	logic rst;

  logic 				key_in_valid;
	logic [1:0] 	key_in_type;
	logic [127:0] key_in, key_out;
	logic [3:0] 	key_addr;
	logic 				key_loaded;

	always begin
  	#1 clk = ~clk;
	end

	initial
		begin
	  	rst = 1;
			clk = 1;
	  	#100
	  	rst = 0;
	  	#120
	  	$display("key_loaded %b", key_loaded);
	  	$display("key_addr %b", key_addr);
			#2000
			$stop;
		end

	initial begin
	  key_in_valid 	= 0;
		key_in_type 	= 0;
		key_in 				= 0;

		#10
		key_in_valid 	= 1;
		key_in_type 	= 2'b10;
	end

	always @ (posedge clk)
  	key_in = key_in + 1;

	//instantiate dut
	key_expansion dut(clk, rst, key_in_valid, key_in_type, key_in,
								key_out, key_addr, key_loaded);

endmodule
