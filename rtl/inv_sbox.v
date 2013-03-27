//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module inv_sbox
  (
   input            clk,
   
   input      [7:0] din,
   output reg [7:0] dout
   );
  
  
   reg [7:0]        inv_sbox [0:255];


   // Initialize the Memory
   `ifdef USING_RUNSIM
   initial $readmemh("../rtl/inv_sbox.dat", inv_sbox);
   `else
   initial $readmemh("inv_sbox.dat", inv_sbox);
   `endif
  

   // Read Only Memory
   always @(posedge clk)
     dout <= inv_sbox[din];
   
   
endmodule

