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
   
   output reg [7:0] o0,
   output reg [7:0] o1,
   output reg [7:0] o2,
   output reg [7:0] o3
   );

   wire [7:0]       m0,   m1,   m2,   m3;
   wire [7:0]       r0_4, r1_4, r2_4, r3_4;
   wire [7:0]       r0_8, r1_8, r2_8, r3_8;
   wire [7:0]       r0_c, r1_c, r2_c, r3_c;

   // Galios Field multiply 4
   assign r0_4 = {i0[5:0], 1'b0} ^ ((i0[7]) ? 8'h36 : 8'h00) ^ ((i0[6]) ? 8'h1B : 8'h00);
   assign r1_4 = {i1[5:0], 1'b0} ^ ((i1[7]) ? 8'h36 : 8'h00) ^ ((i1[6]) ? 8'h1B : 8'h00);
   assign r2_4 = {i2[5:0], 1'b0} ^ ((i2[7]) ? 8'h36 : 8'h00) ^ ((i2[6]) ? 8'h1B : 8'h00);
   assign r3_4 = {i3[5:0], 1'b0} ^ ((i3[7]) ? 8'h36 : 8'h00) ^ ((i3[6]) ? 8'h1B : 8'h00);

   // Galios Field multiply 8
   assign r0_8 = {i0[4:0], 1'b0} ^ ((i0[7]) ? 8'h6c : 8'h00) ^ ((i0[6]) ? 8'h36 : 8'h00) ^ ((i0[5]) ? 8'h1B : 8'h00);
   assign r1_8 = {i1[4:0], 1'b0} ^ ((i1[7]) ? 8'h6c : 8'h00) ^ ((i1[6]) ? 8'h36 : 8'h00) ^ ((i1[5]) ? 8'h1B : 8'h00);
   assign r2_8 = {i2[4:0], 1'b0} ^ ((i2[7]) ? 8'h6c : 8'h00) ^ ((i2[6]) ? 8'h36 : 8'h00) ^ ((i2[5]) ? 8'h1B : 8'h00);
   assign r3_8 = {i3[4:0], 1'b0} ^ ((i3[7]) ? 8'h6c : 8'h00) ^ ((i3[6]) ? 8'h36 : 8'h00) ^ ((i3[5]) ? 8'h1B : 8'h00);

   // Galios Field multiply 12
   assign r0_c = r0_4 ^ r0_8;
   assign r1_c = r1_4 ^ r1_8;
   assign r2_c = r2_4 ^ r2_8;
   assign r3_c = r3_4 ^ r3_8;
   
   // Output terms
   assign o0 = m0 ^ r0_c ^ r1_8 ^ r2_c ^ r3_8;
   assign o1 = m1 ^ r0_8 ^ r1_c ^ r2_8 ^ r3_c;
   assign o2 = m2 ^ r0_c ^ r1_8 ^ r2_c ^ r3_8;
   assign o3 = m3 ^ r0_8 ^ r1_c ^ r2_8 ^ r3_c;


   // Terms from regular Mix Col
   mix_bytes
     u_mix_bytes
       (.i0(i0), .i1(i1), .i2(i2), .i3(i3),
        .o0(m0), .o1(m1), .o2(m2), .o3(m3));
   
   
endmodule

