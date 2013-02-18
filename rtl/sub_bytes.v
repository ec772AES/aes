//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module sub_bytes
  (
   input              clk,
   
   input      [127:0] din,
   output reg [127:0] dout
   );
  

   // Substitute on a per byte basis
   sbox u_sbox_0 (.clk (clk), .din(din[  7:  0]), .dout(dout[  7:  0]));
   sbox u_sbox_1 (.clk (clk), .din(din[ 15:  8]), .dout(dout[ 15:  8]));
   sbox u_sbox_2 (.clk (clk), .din(din[ 23: 16]), .dout(dout[ 23: 16]));
   sbox u_sbox_3 (.clk (clk), .din(din[ 31: 24]), .dout(dout[ 31: 24]));
   sbox u_sbox_4 (.clk (clk), .din(din[ 39: 32]), .dout(dout[ 39: 32]));
   sbox u_sbox_5 (.clk (clk), .din(din[ 47: 40]), .dout(dout[ 47: 40]));
   sbox u_sbox_6 (.clk (clk), .din(din[ 55: 48]), .dout(dout[ 55: 48]));
   sbox u_sbox_7 (.clk (clk), .din(din[ 63: 56]), .dout(dout[ 63: 56]));
   sbox u_sbox_8 (.clk (clk), .din(din[ 71: 64]), .dout(dout[ 71: 64]));
   sbox u_sbox_9 (.clk (clk), .din(din[ 79: 72]), .dout(dout[ 79: 72]));
   sbox u_sbox_a (.clk (clk), .din(din[ 87: 80]), .dout(dout[ 87: 80]));
   sbox u_sbox_b (.clk (clk), .din(din[ 95: 88]), .dout(dout[ 95: 88]));
   sbox u_sbox_c (.clk (clk), .din(din[103: 96]), .dout(dout[103: 96]));
   sbox u_sbox_d (.clk (clk), .din(din[111:104]), .dout(dout[111:104]));
   sbox u_sbox_e (.clk (clk), .din(din[119:112]), .dout(dout[119:112]));
   sbox u_sbox_f (.clk (clk), .din(din[127:120]), .dout(dout[127:120]));
   
   
endmodule

