//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module add_rkey
  (
   input      [127:0] rkey,
   input      [127:0] din,
   output reg [127:0] dout
   );


   assign dout = din ^ rkey;
  
   
endmodule

