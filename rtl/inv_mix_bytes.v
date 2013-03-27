//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module inv_mix_bytes
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
   wire [7:0]       r0_4, r1_4, r2_4, r3_4;
   wire [7:0]       r0_5, r1_5, r2_5, r3_5;
   wire [7:0]       r0_6, r1_6, r2_6, r3_6;
   wire [7:0]       r0_7, r1_7, r2_7, r3_7;
   wire [7:0]       r0_8, r1_8, r2_8, r3_8;
   wire [7:0]       r0_9, r1_9, r2_9, r3_9;
   wire [7:0]       r0_a, r1_a, r2_a, r3_a;
   wire [7:0]       r0_b, r1_b, r2_b, r3_b;
   wire [7:0]       r0_c, r1_c, r2_c, r3_c;
   wire [7:0]       r0_d, r1_d, r2_d, r3_d;
   wire [7:0]       r0_e, r1_e, r2_e, r3_e;

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
   
   // Galios Field multiply 4
   gf_mul2 u_gf_4 (.i0(r0_2), .o0(r0_4),
                   .i1(r1_2), .o1(r1_4),
                   .i2(r2_2), .o2(r2_4),
                   .i3(r3_2), .o3(r3_4));

   // Galios Field multiply 5
   assign r0_5 = r0_1 ^ r0_4;
   assign r1_5 = r1_1 ^ r1_4;
   assign r2_5 = r2_1 ^ r2_4;
   assign r3_5 = r3_1 ^ r3_4;

   // Galios Field multiply 6
   gf_mul2 u_gf_6 (.i0(r0_3), .o0(r0_6),
                   .i1(r1_3), .o1(r1_6),
                   .i2(r2_3), .o2(r2_6),
                   .i3(r3_3), .o3(r3_6));

   // Galios Field multiply 7
   assign r0_7 = r0_1 ^ r0_6;
   assign r1_7 = r1_1 ^ r1_6;
   assign r2_7 = r2_1 ^ r2_6;
   assign r3_7 = r3_1 ^ r3_6;

   // Galios Field multiply 8
   gf_mul2 u_gf_8 (.i0(r0_4), .o0(r0_8),
                   .i1(r1_4), .o1(r1_8),
                   .i2(r2_4), .o2(r2_8),
                   .i3(r3_4), .o3(r3_8));

   // Galios Field multiply 9
   assign r0_9 = r0_1 ^ r0_8;
   assign r1_9 = r1_1 ^ r1_8;
   assign r2_9 = r2_1 ^ r2_8;
   assign r3_9 = r3_1 ^ r3_8;

   // Galios Field multiply 10
   gf_mul2 u_gf_a (.i0(r0_5), .o0(r0_a),
                   .i1(r1_5), .o1(r1_a),
                   .i2(r2_5), .o2(r2_a),
                   .i3(r3_5), .o3(r3_a));
   
   // Galios Field multiply 11
   assign r0_b = r0_1 ^ r0_a;
   assign r1_b = r1_1 ^ r1_a;
   assign r2_b = r2_1 ^ r2_a;
   assign r3_b = r3_1 ^ r3_a;

   // Galios Field multiply 12
   gf_mul2 u_gf_c (.i0(r0_6), .o0(r0_c),
                   .i1(r1_6), .o1(r1_c),
                   .i2(r2_6), .o2(r2_c),
                   .i3(r3_6), .o3(r3_c));

   // Galios Field multiply 13
   assign r0_d = r0_1 ^ r0_c;
   assign r1_d = r1_1 ^ r1_c;
   assign r2_d = r2_1 ^ r2_c;
   assign r3_d = r3_1 ^ r3_c;

   // Galios Field multiply 14
   gf_mul2 u_gf_e (.i0(r0_7), .o0(r0_e),
                   .i1(r1_7), .o1(r1_e),
                   .i2(r2_7), .o2(r2_e),
                   .i3(r3_7), .o3(r3_e));
   
   // Output terms
   assign o0 = r0_e ^ r1_b ^ r2_d ^ r3_9;
   assign o1 = r0_9 ^ r1_e ^ r2_b ^ r3_d;
   assign o2 = r0_d ^ r1_9 ^ r2_e ^ r3_b;
   assign o3 = r0_b ^ r1_d ^ r2_9 ^ r3_e;
   
   
endmodule

