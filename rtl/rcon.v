//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module rcon
  (
   input         clk,
   input         rst,
   input [3:0]   addr,
   output reg [31:0] dout
   );

   reg [3:0]     addr_r;

   always @(posedge clk)
     if (rst)
       addr_r <= 0;
     else
       addr_r <= addr;

   always @(*)
     case (addr_r)
       4'h0: dout = 32'h01000000;
       4'h1: dout = 32'h02000000;
       4'h2: dout = 32'h04000000;
       4'h3: dout = 32'h08000000;
       4'h4: dout = 32'h10000000;
       4'h5: dout = 32'h20000000;
       4'h6: dout = 32'h40000000;
       4'h7: dout = 32'h80000000;
       4'h8: dout = 32'h1b000000;
       4'h9: dout = 32'h36000000;
       4'ha: dout = 32'h00000000;
       4'hb: dout = 32'h00000000;
       4'hc: dout = 32'h00000000;
       4'hd: dout = 32'h00000000;
       4'he: dout = 32'h00000000;
       4'hf: dout = 32'h00000000;
     endcase

endmodule