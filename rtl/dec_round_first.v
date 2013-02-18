//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module dec_round_first
  (
   input          clk,
   input [127:0]  rkey,
   input [127:0]  din,
   output [127:0] dout
   );

   wire [127:0]       addkey_2_shiftrows;
   wire [127:0]       shiftrows_2_subbytes;

   add_rkey
     u_add_rkey
       (.rkey (rkey),
        .din  (din),
        .dout (addkey_2_shiftrows));

   shift_rows
     u_shift_rows
       (.din  (addkey_2_shiftrows),
        .dout (shiftrows_2_subbytes));
   
   sub_bytes
     u_sub_bytes
       (.clk  (clk),
        .din  (shiftrows_2_subbytes),
        .dout (dout));
  
   
endmodule

