//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module key_expansion_logic(
    input          clk,
    input          rst,
    input          load_enable,
    input [127:0]  key_in,
    input [31:0]   rcon_in,
    output [127:0] key_out);


   reg [31:0]      R0, R1, R2, R3;
   wire [7:0]      sbyte0, sbyte1, sbyte2, sbyte3;
   wire [31:0]     W0, W1, W2, W3;
   wire [31:0]     rotword;
   wire [31:0]     sbyte_in;
   

   assign key_out = {R0, R1, R2, R3};
   
   always @(posedge clk)
     if (rst)
       begin
          R0 <= 0;
          R1 <= 0;
          R2 <= 0;
          R3 <= 0;
       end
     else
       if (load_enable)
         begin
            R0 <= key_in[127:96];
            R1 <= key_in[ 95:64];
            R2 <= key_in[ 63:32];
            R3 <= key_in[ 31: 0];
         end
       else
         begin
            R0 <= W0;
            R1 <= W1;
            R2 <= W2;
            R3 <= W3;
         end
   
   assign W0 = R0 ^ rotword ^ rcon_in;
   assign W1 = R1 ^ W0;
   assign W2 = R2 ^ W1;
   assign W3 = R3 ^ W2;

   assign rotword = {sbyte2, sbyte1, sbyte0, sbyte3};
   
   assign sbyte_in = load_enable ? key_in[31:0] : W3;
   

   sbox u_sbox_byte0(
                     .clk(clk),
                     .din(sbyte_in[ 7: 0]),
                     .dout(sbyte0));
   
   sbox u_sbox_byte1(
                     .clk(clk),
                     .din(sbyte_in[15: 8]),
                     .dout(sbyte1));

   sbox u_sbox_byte2(
                     .clk(clk),
                     .din(sbyte_in[23:16]),
                     .dout(sbyte2));
   
   sbox u_sbox_byte3(
                     .clk(clk),
                     .din(sbyte_in[31:24]),
                     .dout(sbyte3));

endmodule
