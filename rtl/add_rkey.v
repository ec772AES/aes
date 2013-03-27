//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module add_rkey
  (
   input              clk,
   input              rst,
   input      [127:0] rkey,
   input      [3:0]   addr,
   input      [127:0] din,
   output     [127:0] dout
   );

  parameter ADDRESS = 4'd0;

  reg [127:0] key;

  // Add the round key to the data
  assign    dout = din ^ key;

  
  // Register the round key
  always @(posedge clk)
    if (rst)
      key <= 128'd0;
    else
      if (addr == ADDRESS)
        key <= rkey;
      else
        key <= key;
  
   
endmodule

