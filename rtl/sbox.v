//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module sbox
  (
   input            clk,
   
   input      [7:0] din,
   output reg [7:0] dout
   );
  
  
   reg [7:0]        sbox [0:7];


   // Initialize the Memory
   initial $readmemh("../rtl/sbox.dat", sbox);
  

   // Read Only Memory
   always @(posedge clk)
     dout <= sbox[din];
   
   
endmodule

