//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module convert_aes_block
  (
   // Convert block to bytes
   input  [127:0] blk2byt,
   output [  7:0] blk2byt00, blk2byt01, blk2byt02, blk2byt03,
                  blk2byt10, blk2byt11, blk2byt12, blk2byt13,
                  blk2byt20, blk2byt21, blk2byt22, blk2byt23,
                  blk2byt30, blk2byt31, blk2byt32, blk2byt33,
   
   // Convert bytes to blocks
   input  [  7:0] byt2blk00, byt2blk01, byt2blk02, byt2blk03,
                  byt2blk10, byt2blk11, byt2blk12, byt2blk13,
                  byt2blk20, byt2blk21, byt2blk22, byt2blk23,
                  byt2blk30, byt2blk31, byt2blk32, byt2blk33,
   output [127:0] byt2blk
   );

   // Convert block to bytes
   assign blk2byt00 = blk2byt[127:120];
   assign blk2byt10 = blk2byt[119:112];
   assign blk2byt20 = blk2byt[111:104];
   assign blk2byt30 = blk2byt[103: 96];
   assign blk2byt01 = blk2byt[ 95: 88];
   assign blk2byt11 = blk2byt[ 87: 80];
   assign blk2byt21 = blk2byt[ 79: 72];
   assign blk2byt31 = blk2byt[ 71: 64];
   assign blk2byt02 = blk2byt[ 63: 56];
   assign blk2byt12 = blk2byt[ 55: 48];
   assign blk2byt22 = blk2byt[ 47: 40];
   assign blk2byt32 = blk2byt[ 39: 32];
   assign blk2byt03 = blk2byt[ 31: 24];
   assign blk2byt13 = blk2byt[ 23: 16];
   assign blk2byt23 = blk2byt[ 15:  8];
   assign blk2byt33 = blk2byt[  7:  0];

   // Convert bytes to blocks
   assign byt2blk[127:120] = byt2blk00;
   assign byt2blk[119:112] = byt2blk10;
   assign byt2blk[111:104] = byt2blk20;
   assign byt2blk[103: 96] = byt2blk30;
   assign byt2blk[ 95: 88] = byt2blk01;
   assign byt2blk[ 87: 80] = byt2blk11;
   assign byt2blk[ 79: 72] = byt2blk21;
   assign byt2blk[ 71: 64] = byt2blk31;
   assign byt2blk[ 63: 56] = byt2blk02;
   assign byt2blk[ 55: 48] = byt2blk12;
   assign byt2blk[ 47: 40] = byt2blk22;
   assign byt2blk[ 39: 32] = byt2blk32;
   assign byt2blk[ 31: 24] = byt2blk03;
   assign byt2blk[ 23: 16] = byt2blk13;
   assign byt2blk[ 15:  8] = byt2blk23;
   assign byt2blk[  7:  0] = byt2blk33;

      
endmodule

