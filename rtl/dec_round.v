//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module dec_round
  (
   input          clk,
   input [127:0]  rkey,
   input [127:0]  din,
   output [127:0] dout
   );

   wire [127:0]       addkey_2_mixcols;
   wire [127:0]       mixcols_2_shiftrows;
   wire [127:0]       shiftrows_2_subbytes;

   add_rkey
     u_add_rkey
       (.rkey (rkey),
        .din  (din),
        .dout (addkey_2_mixcols));

   mix_cols
     u_mix_cols
       (.din  (addkey_2_mixcols),
        .dout (mixcols_2_shiftrows));

   shift_rows
     u_shift_rows
       (.din  (mixcols_2_shiftrows),
        .dout (shiftrows_2_subbytes));
   
   sub_bytes
     u_sub_bytes
       (.clk  (clk),
        .din  (shiftrows_2_subbytes),
        .dout (dout));
  
   
endmodule

