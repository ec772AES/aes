//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module mix_cols
  (
   input      [127:0] din,
   output     [127:0] dout
   );


   wire [7:0] di00, di01, di02, di03,
              di10, di11, di12, di13,
              di20, di21, di22, di23,
              di30, di31, di32, di33;

   wire [7:0] do00, do01, do02, do03,
              do10, do11, do12, do13,
              do20, do21, do22, do23,
              do30, do31, do32, do33;


   convert_aes_block
     u_convert
       (
        // Convert from 128-bit block to 16 bytes
        .blk2byt  (din),
        .blk2byt00(di00), .blk2byt01(di01), .blk2byt02(di02), .blk2byt03(di03),
        .blk2byt10(di10), .blk2byt11(di11), .blk2byt12(di12), .blk2byt13(di13),
        .blk2byt20(di20), .blk2byt21(di21), .blk2byt22(di22), .blk2byt23(di23),
        .blk2byt30(di30), .blk2byt31(di31), .blk2byt32(di32), .blk2byt33(di33),

        // Convert from 16 bytes to 128-bit block
        .byt2blk00(do00), .byt2blk01(do01), .byt2blk02(do02), .byt2blk03(do03),
        .byt2blk10(do10), .byt2blk11(do11), .byt2blk12(do12), .byt2blk13(do13),
        .byt2blk20(do20), .byt2blk21(do21), .byt2blk22(do22), .byt2blk23(do23),
        .byt2blk30(do30), .byt2blk31(do31), .byt2blk32(do32), .byt2blk33(do33),
        .byt2blk  (dout)
        );


   // Mix Cols
   mix_bytes u_mix_bytes_0
     (.i0(di00), .i1(di10), .i2(di20), .i3(di30),
      .o0(do00), .o1(do10), .o2(do20), .o3(do30));

   mix_bytes u_mix_bytes_1
     (.i0(di01), .i1(di11), .i2(di21), .i3(di31),
      .o0(do01), .o1(do11), .o2(do21), .o3(do31));

   mix_bytes u_mix_bytes_2
     (.i0(di02), .i1(di12), .i2(di22), .i3(di32),
      .o0(do02), .o1(do12), .o2(do22), .o3(do32));

   mix_bytes u_mix_bytes_3
     (.i0(di03), .i1(di13), .i2(di23), .i3(di33),
      .o0(do03), .o1(do13), .o2(do23), .o3(do33));
  
   
endmodule

