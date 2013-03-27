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
   gf_mul2 u_gf_2 (.i0(r0_1), .o0(r0_2),
                   .i1(r1_1), .o1(r1_2),
                   .i2(r2_1), .o2(r2_2),
                   .i3(r3_1), .o3(r3_2));
   
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

