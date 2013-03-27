//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module gf_mul2
  (
   input [7:0]      i0,
   input [7:0]      i1,
   input [7:0]      i2,
   input [7:0]      i3,
   
   output [7:0] o0,
   output [7:0] o1,
   output [7:0] o2,
   output [7:0] o3
   );

   // Galios Field multiply 2
   assign o0 = {i0[6:0], 1'b0} ^ ((i0[7]) ? 8'h1B : 8'h00);
   assign o1 = {i1[6:0], 1'b0} ^ ((i1[7]) ? 8'h1B : 8'h00);
   assign o2 = {i2[6:0], 1'b0} ^ ((i2[7]) ? 8'h1B : 8'h00);
   assign o3 = {i3[6:0], 1'b0} ^ ((i3[7]) ? 8'h1B : 8'h00);
   
   
endmodule

