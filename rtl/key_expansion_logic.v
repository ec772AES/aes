//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module key_expansion_logic(
	input 				clk,
	input 				rst,
	input					load_enable,
	input [127:0] key_in,
	input [31:0] 	rcon_in,
	output [127:0] key_out);

	reg  [31:0] R0, R1, R2, R3;
	wire [31:0] W0, W1, W2, W3;
	wire [7:0] 	sbyte0, sbyte1, sbyte2, sbyte3;

	/* Clock the pipeline or reset */
	always @(posedge clk or posedge rst)
		if (rst) begin
			R0 <= 32'd0;
			R1 <= 32'd0;
			R2 <= 32'd0;
			R3 <= 32'd0;
		end else begin
			/* Note that this read-in is convoluted. I assume bit 0 is received first and bit 128 last */
			/* Not sure why convoluted, but read in normally */
			R0 <= load_enable ? {key_in[ 31: 24], key_in[ 23: 16], key_in[ 15:  8], key_in[  7: 0]} : W0;
			R1 <= load_enable ? {key_in[ 63: 56], key_in[ 55: 48], key_in[ 47: 40], key_in[ 39:32]} : W1;
			R2 <= load_enable ? {key_in[ 95: 88], key_in[ 87: 80], key_in[ 79: 72], key_in[ 71:64]} : W2;
			R3 <= load_enable ? {key_in[127:120], key_in[119:112], key_in[111:104], key_in[103:96]} : W3;

		//	R0 <= load_enable ? {key_in[  7: 0], key_in[ 15:  8], key_in[ 23: 16], key_in[ 31: 24]} : W0;
		//	R1 <= load_enable ? {key_in[ 39:32], key_in[ 47: 40], key_in[ 55: 48], key_in[ 63: 56]} : W1;
		//	R2 <= load_enable ? {key_in[ 71:64], key_in[ 79: 72], key_in[ 87: 80], key_in[ 95: 88]} : W2;
		//	R3 <= load_enable ? {key_in[103:96], key_in[111:104], key_in[119:112], key_in[127:120]} : W3;
		end

  /* Set to 0 if rst is 1 to give a default value after reset, MP */
	assign W0 = (rst) ? 0 : (load_enable ? R0 : R0 ^ {sbyte3, sbyte2, sbyte1, sbyte0} ^ rcon_in);
	assign W1 = (rst) ? 0 : (load_enable ? R1 : R1 ^ W0);
	assign W2 = (rst) ? 0 : (load_enable ? R2 : R2 ^ W1);
	assign W3 = (rst) ? 0 : (load_enable ? R3 : R3 ^ W2); /* longest path 2 memory retrivals (in parallel) and 5 xors. */

	assign key_out = {R3, R2, R1, R0};

	/* We do the cyclic byte-wise left shift with the addressing of the sbox's */
	sbox u_sbox_byte0(
					.clk(clk),
					.din(W3[31:24]),
					.dout(sbyte0));

	sbox u_sbox_byte1(
					.clk(clk),
					.din(W3[7:0]),
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
