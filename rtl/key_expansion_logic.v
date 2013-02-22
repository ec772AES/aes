//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module key_expansion_logic(
	input 			clk,
	input 			rst,
	input				load_enable,
	input [127:0] 	key_in,
	input [31:0] 	rcon_in,
	input [127:0] 	key_out)
	
	reg  [31:0] B0, B1, B2, B4;
	wire [31:0] W0, W1, W2, W3;
	wire [7:0] 	sbyte0, sbyte1, sbyte2, sbyte3;

	/* Clock the pipeline or reset */
	always @(posedge clk or posedge rst)
		if (rst) begin
			B0 <= 8'd0;
			B1 <= 8'd0;
			B2 <= 8'd0;
			B3 <= 8'd0;
		end else begin
			/* Note that this read-in is convoluted. I assume bit 0 is received first and bit 128 last */
			B0 <= load_enable ? [key_in[  7: 0] key_in[ 15:  8] key_in[ 23: 16] key_in[ 31: 24]] : W0;
			B1 <= load_enable ? [key_in[ 39:32] key_in[ 47: 40] key_in[ 55: 48] key_in[ 63: 56]] : W1;
			B2 <= load_enable ? [key_in[ 71:64] key_in[ 79: 72] key_in[ 87: 80] key_in[ 95: 88]] : W2;
			B3 <= load_enable ? [key_in[103:96] key_in[111:104] key_in[119:112] key_in[127:120]] : W3;
		end
		
	assign W0 = load_enable ? B0 : B0 ^ [sbyte3 sbyte2 sbyte1 sbyte0] ^ rcon_in;
	assign W1 = load_enable ? B1 : B1 ^ W0;
	assign W2 = load_enable ? B2 : B2 ^ W1;
	assign W3 = load_enable ? B3 : B3 ^ W2; /* longest path 2 memory retrivals (in parallel) and 5 xors. */
	
	assign key_out = [B3 B2 B1 B0];
	
	/* We do the cyclic byte-wise left shift with the addressing of the sbox's */
	sbox u_sbox_byte0(
					.clk(clk),
					.din(W3[31:24]),
					.dout(sbyte0));

	sbox u_sbox_byte1(
					.clk(clk),
					.din(W3[0:7]),
					.dout(sbyte1));

	sbox u_sbox_byte2(
					.clk(clk),
					.din(W3[15:8]),
					.dout(sbyte2));

	sbox u_sbox_byte3(
					.clk(clk),
					.din(W3[23:16]),
					.dout(sbyte3));	
	
endmodule
