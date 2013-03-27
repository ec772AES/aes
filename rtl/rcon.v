//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module rcon
  (
   input             clk,
   input      [3:0]  addr, /* use only addresses 0...10!! */
   output reg [31:0] dout
   );


   reg [31:0]        rcon [0:15];


   // Initialize the Memory
   `ifdef USING_RUNSIM
   initial $readmemh("../rtl/rcon.dat", rcon);
   `else
   initial $readmemh("rcon.dat", rcon);
   `endif


   // Read Only Memory
   always @(posedge clk) begin
     dout <= rcon[addr];
     end


endmodule
