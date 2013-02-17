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

   
   // Convert from 128-bit block to 16 bytes
   block_to_bytes
     u_block_to_bytes
       (.d  (din),
        .d00(d00), .d01(d01), .d02(d02), .d03(d03),
        .d10(d10), .d11(d11), .d12(d12), .d13(d13),
        .d20(d20), .d21(d21), .d22(d22), .d23(d23),
        .d30(d30), .d31(d31), .d32(d32), .d33(d33));


   // Convert from 16 bytes to 128-bit block
   block_to_bytes
     u_block_to_bytes
       (.d  (dout),

        // Shift Rows
        .d00(d00), .d01(d01), .d02(d02), .d03(d03),
        .d10(d11), .d11(d12), .d12(d13), .d13(d10),
        .d20(d22), .d21(d23), .d22(d20), .d23(d21),
        .d30(d33), .d31(d30), .d32(d31), .d33(d32));
   
   
endmodule

