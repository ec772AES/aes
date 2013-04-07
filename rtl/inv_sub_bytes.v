//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module inv_sub_bytes
  (
   input              clk,
	 input 							rst,
   input      [127:0] din,
   output reg [127:0] dout
   );


   // Substitute on a per byte basis
   inv_sbox u_inv_sbox_0 (.clk (clk), .rst(rst), .din(din[  7:  0]), .dout(dout[  7:  0]));
   inv_sbox u_inv_sbox_1 (.clk (clk), .rst(rst), .din(din[ 15:  8]), .dout(dout[ 15:  8]));
   inv_sbox u_inv_sbox_2 (.clk (clk), .rst(rst), .din(din[ 23: 16]), .dout(dout[ 23: 16]));
   inv_sbox u_inv_sbox_3 (.clk (clk), .rst(rst), .din(din[ 31: 24]), .dout(dout[ 31: 24]));
   inv_sbox u_inv_sbox_4 (.clk (clk), .rst(rst), .din(din[ 39: 32]), .dout(dout[ 39: 32]));
   inv_sbox u_inv_sbox_5 (.clk (clk), .rst(rst), .din(din[ 47: 40]), .dout(dout[ 47: 40]));
   inv_sbox u_inv_sbox_6 (.clk (clk), .rst(rst), .din(din[ 55: 48]), .dout(dout[ 55: 48]));
   inv_sbox u_inv_sbox_7 (.clk (clk), .rst(rst), .din(din[ 63: 56]), .dout(dout[ 63: 56]));
   inv_sbox u_inv_sbox_8 (.clk (clk), .rst(rst), .din(din[ 71: 64]), .dout(dout[ 71: 64]));
   inv_sbox u_inv_sbox_9 (.clk (clk), .rst(rst), .din(din[ 79: 72]), .dout(dout[ 79: 72]));
   inv_sbox u_inv_sbox_a (.clk (clk), .rst(rst), .din(din[ 87: 80]), .dout(dout[ 87: 80]));
   inv_sbox u_inv_sbox_b (.clk (clk), .rst(rst), .din(din[ 95: 88]), .dout(dout[ 95: 88]));
   inv_sbox u_inv_sbox_c (.clk (clk), .rst(rst), .din(din[103: 96]), .dout(dout[103: 96]));
   inv_sbox u_inv_sbox_d (.clk (clk), .rst(rst), .din(din[111:104]), .dout(dout[111:104]));
   inv_sbox u_inv_sbox_e (.clk (clk), .rst(rst), .din(din[119:112]), .dout(dout[119:112]));
   inv_sbox u_inv_sbox_f (.clk (clk), .rst(rst), .din(din[127:120]), .dout(dout[127:120]));


endmodule
