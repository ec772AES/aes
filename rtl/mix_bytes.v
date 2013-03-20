//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module mix_bytes
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
   
   wire [7:0]       r0_1, r1_1, r2_1, r3_1;
   wire [7:0]       r0_2, r1_2, r2_2, r3_2;
   wire [7:0]       r0_3, r1_3, r2_3, r3_3;


   // Galios Field multiply 1
   assign r0_1 = i0;
   assign r1_1 = i1;
   assign r2_1 = i2;
   assign r3_1 = i3;

   // Galios Field multiply 2
   assign r0_2 = {r0_1[6:0], 1'b0} ^ ((r0_1[7]) ? 8'h1B : 8'h00);
   assign r1_2 = {r1_1[6:0], 1'b0} ^ ((r1_1[7]) ? 8'h1B : 8'h00);
   assign r2_2 = {r2_1[6:0], 1'b0} ^ ((r2_1[7]) ? 8'h1B : 8'h00);
   assign r3_2 = {r3_1[6:0], 1'b0} ^ ((r3_1[7]) ? 8'h1B : 8'h00);

   // Galios Field multiply 3
   assign r0_3 = r0_1 ^ r0_2;
   assign r1_3 = r1_1 ^ r1_2;
   assign r2_3 = r2_1 ^ r2_2;
   assign r3_3 = r3_1 ^ r3_2;

   // Ouptut terms
   assign o0 = r0_2 ^ r1_3 ^ r2_1 ^ r3_1;
   assign o1 = r0_1 ^ r1_2 ^ r2_3 ^ r3_1;
   assign o2 = r0_1 ^ r1_1 ^ r2_2 ^ r3_3;
   assign o3 = r0_3 ^ r1_1 ^ r2_1 ^ r3_2;
   
   
endmodule

