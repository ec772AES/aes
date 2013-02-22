//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module key_expansion(
	input 			clk, 				/* clock */
	input 			rst, 				/* reset line -- high active */
	input 			key_in_valid, 	/* valid input key at key_in */
	input  [127:0] key_in, 			/* input key I ASSUME bit0 is the first bit received and bit 128 the last one.*/
	output [127:0] key_out, 		/* output to register's in Ben's design */
	output [3:0] 	key_addr,		/* 1,...,11 for 11 keys, 0 nonvalid addr */
	output 			key_loaded); 	/* key completely loaded */
	
	localparam READY		= 4'd0,
				  INIT 		= 4'd1,
				  ROUND_1 	= 4'd2,
				  ROUND_2 	= 4'd3,
				  ROUND_3 	= 4'd4,
				  ROUND_4 	= 4'd5,
				  ROUND_5 	= 4'd6,
				  ROUND_6 	= 4'd7,
				  ROUND_7 	= 4'd8,
				  ROUND_8 	= 4'd9,
				  ROUND_9 	= 4'd10,
				  ROUND_10 	= 4'd11,
				  DONE 		= 4'd12;
	
	/* four bits for state */
	reg [3:0] state, next;
	
	reg  [31:0] B0, B1, B2, B4;
	wire [31:0] W0, W1, W2, W3;
	wire [31:0] rcon_out, sub_bytes_out, rot_bytes_out;
	wire [3:0] rcon_addr;
	wire load_enable;	
	
	/* shift to next state allow for async reset */
	always @(posedge clk or posedge rest)
		if (rst) state <= READY;
		else begin
			state <= next;
			/* Note that this read in is very convoluted. I assume bit 0 is received first and bit 128 last */
			B0 <= load_enable ? [key_in[  7: 0] key_in[ 15:  8] key_in[ 23: 16] key_in[ 31: 24]] : W0;
			B1 <= load_enable ? [key_in[ 39:32] key_in[ 47: 40] key_in[ 55: 48] key_in[ 63: 56]] : W1;
			B2 <= load_enable ? [key_in[ 71:64] key_in[ 79: 72] key_in[ 87: 80] key_in[ 95: 88]] : W2;
			B3 <= load_enable ? [key_in[103:96] key_in[111:104] key_in[119:112] key_in[127:120]] : W3;
		end
	
	/* next state combinational logic */
	always @(state or key_in_valid) begin
		next 			= 4'bxxxx;
		key_out 		= 'b0;
		load_enable = 'b0;
		key_loaded 	= 'b0;
		key_addr 	= 4'd0;
		rcon_addr 	= 4'd0; /* note that rcon_addr is not always key_addr - 1 */
		case (state)
			READY : if (key_in_valid) begin
						next 			= INIT;
						load_enable = 'b1;
					  end else 				
						next 			= READY;
			INIT : begin 							  /* B0 B1 B2 B3 all set */
						next 		= ROUND_1;
						key_addr = 4'd1; 			  /* 1st key ready */
					 end
			ROUND_1 : begin
							next 			= ROUND_2; /* 2nd key ready */
							key_addr 	= 4'd2;
							rcon_addr 	= 4'd1;
					    end
			ROUND_2 : begin
							next 			= ROUND_3; /* 3rd key ready */
							key_addr 	= 4'd3;
							rcon_addr 	= 4'd2;
					 	 end
			ROUND_3 : begin
							next 			= ROUND_4; /* 4th key ready */
							key_addr 	= 4'd4;
							rcon_addr 	= 4'd3;
						 end
			ROUND_4 : begin
							next 			= ROUND_5; /* 5th key ready */
							key_addr 	= 4'd5;
							rcon_addr 	= 4'd4;
						end
			ROUND_5 : begin
							next 			= ROUND_6; /* 6th key ready */
							key_addr 	= 4'd6;
							rcon_addr 	= 4'd5;
						end
			ROUND_6 : begin
							next 			= ROUND_7; /* 7th key ready */
							key_addr 	= 4'd7;
							rcon_addr 	= 4'd6;
						end
			ROUND_7 : begin
							next 			= ROUND_8; /* 8th key ready */
							key_addr 	= 4'd8;
							rcon_addr 	= 4'd7;
						end
			ROUND_8 : begin
							next 			= ROUND_9; /* 9th key ready */
							key_addr 	= 4'd9;
							rcon_addr 	= 4'd8;
						end
			ROUND_9 : begin
							next 			= ROUND_10; /* 10th key ready */
							key_addr 	= 4'd10;
							rcon_addr 	= 4'd9;
						end
			ROUND_10 : begin
							next 			= DONE; 		/* 11th key ready */
							key_addr 	= 4'd11;
						end
			DONE : begin
						next = DONE;
						key_loaded = 'b1;
					 end
	end
	
	rcon u_rcon(
				.clk(clk),
				.addr(rcon_addr),
				.dout(rcon_out));
				
	sub_bytes u_sub_bytes(
					.clk(clk),
					.din(rot_bytes_out), /* 128 bit, but only the lowest 32bits are used ??? */
					.dout(sub_bytes_out)); /* 128 bit, but only the lowest 32bits are used ??? */ 
	
	rot_byte u_rot_bytes(
					.din(W3), /* 32bit input */
					.dout(rot_bytes_out)); /* 32bit output */
	
	assign W0 = load_enable ? B0 : B0 ^ sub_bytes_out ^ rcon_out;
	assign W1 = load_enable ? B1 : B1 ^ W0;
	assign W2 = load_enable ? B2 : B2 ^ W1;
	assign W3 = load_enable ? B3 : B3 ^ W2; /* longest path 2 memory retrivals (in parallel) and 5 xors. */
	
	assign key_out = [B3 B2 B1 B0];
	
endmodule
