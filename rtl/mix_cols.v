//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module mix_cols
  (
   input      [127:0] din,
   output reg [127:0] dout
   );


   wire [7:0] di00, di01, di02, di03,
              di10, di11, di12, di13,
              di20, di21, di22, di23,
              di30, di31, di32, di33;

   wire [7:0] do00, do01, do02, do03,
              do10, do11, do12, do13,
              do20, do21, do22, do23,
              do30, do31, do32, do33;

   
   // Convert from 128-bit block to 16 bytes
   block_to_bytes
     u_block_to_bytes
       (.d  (din),
        .d00(di00), .d01(di01), .d02(di02), .d03(di03),
        .d10(di10), .d11(di11), .d12(di12), .d13(di13),
        .d20(di20), .d21(di21), .d22(di22), .d23(di23),
        .d30(di30), .d31(di31), .d32(di32), .d33(di33));

   
   // Mix Cols
   mix_col u_mix_col_0
     (.i0(di00), .i1(di10), .i2(di20), .i3(di30),
      .o0(do00), .o1(do10), .o2(do20), .o3(do30));

   mix_col u_mix_col_1
     (.i0(di01), .i1(di11), .i2(di21), .i3(di31),
      .o0(do01), .o1(do11), .o2(do21), .o3(do31));

   mix_col u_mix_col_2
     (.i0(di02), .i1(di12), .i2(di22), .i3(di32),
      .o0(do02), .o1(do12), .o2(do22), .o3(do32));

   mix_col u_mix_col_3
     (.i0(di03), .i1(di13), .i2(di23), .i3(di33),
      .o0(do03), .o1(do13), .o2(do23), .o3(do33));
   

   // Convert from 16 bytes to 128-bit block
   block_to_bytes
     u_block_to_bytes
       (.d  (dout),
        .d00(do00), .d01(do01), .d02(do02), .d03(do03),
        .d10(do10), .d11(do11), .d12(do12), .d13(do13),
        .d20(do20), .d21(do21), .d22(do22), .d23(do23),
        .d30(do30), .d31(do31), .d32(do32), .d33(do33));
   
   
endmodule

