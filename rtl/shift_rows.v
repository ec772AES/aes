//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module shift_rows
  (
   input      [127:0] din,
   output reg [127:0] dout
   );


   wire [7:0] d00, d01, d02, d03,
              d10, d11, d12, d13,
              d20, d21, d22, d23,
              d30, d31, d32, d33;

   
   convert_aes_block
     u_convert
       (
        // Convert from 128-bit block to 16 bytes
        .blk2byt  (din),
        .blk2byt00(d00), .blk2byt01(d01), .blk2byt02(d02), .blk2byt03(d03),
        .blk2byt10(d10), .blk2byt11(d11), .blk2byt12(d12), .blk2byt13(d13),
        .blk2byt20(d20), .blk2byt21(d21), .blk2byt22(d22), .blk2byt23(d23),
        .blk2byt30(d30), .blk2byt31(d31), .blk2byt32(d32), .blk2byt33(d33),

        // Shift Rows
        // Convert from 16 bytes to 128-bit block
        .byt2blk00(d00), .byt2blk01(d01), .byt2blk02(d02), .byt2blk03(d03),
        .byt2blk10(d11), .byt2blk11(d12), .byt2blk12(d13), .byt2blk13(d10),
        .byt2blk20(d22), .byt2blk21(d23), .byt2blk22(d20), .byt2blk23(d21),
        .byt2blk30(d33), .byt2blk31(d30), .byt2blk32(d31), .byt2blk33(d32),
        .byt2blk  (dout)
        );
   
   
endmodule

