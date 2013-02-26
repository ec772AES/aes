//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module enc_round_last
  (
   input          clk,
   input          rst,
   input  [127:0] rkey,
   input  [3:0]   addr,
   input  [127:0] din,
   output [127:0] dout
   );

  parameter       ADDRESS = 4'd0;
  
  wire [127:0]    subbytes_2_shiftrows;
  wire [127:0]    shiftrows_2_addkey;
   
   sub_bytes
     u_sub_bytes
       (.clk  (clk),
        .din  (din),
        .dout (subbytes_2_shiftrows));

   shift_rows
     u_shift_rows
       (.din  (subbytes_2_shiftrows),
        .dout (shiftrows_2_addkey));

   add_rkey #(ADDRESS)
    u_add_rkey
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (shiftrows_2_addkey),
       .dout (dout));
  
   
endmodule

