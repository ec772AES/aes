//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module dec_round_first
  (
   input          clk,
   input          rst,
   input  [127:0] rkey,
   input  [3:0]   addr,
   input  [127:0] din,
   output [127:0] dout
   );

  parameter       ADDRESS = 4'd0;
  
  wire [127:0]    addkey_2_shiftrows;
  wire [127:0]    shiftrows_2_subbytes;

   add_rkey #(ADDRESS)
    u_add_rkey
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (din),
       .dout (addkey_2_shiftrows));

  inv_shift_rows
    u_inv_shift_rows
      (.din  (addkey_2_shiftrows),
       .dout (shiftrows_2_subbytes));
   
  inv_sub_bytes
    u_inv_sub_bytes
      (.clk  (clk),
       .din  (shiftrows_2_subbytes),
       .dout (dout));
  
   
endmodule

