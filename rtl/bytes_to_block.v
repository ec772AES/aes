//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module bytes_to_block
  (
   output [127:0] d,
   input  [  7:0] d00, d01, d02, d03,
                  d10, d11, d12, d13,
                  d20, d21, d22, d23,
                  d30, d31, d32, d33
   );


   assign d[127:120] = d00;
   assign d[119:112] = d01;
   assign d[111:104] = d02;
   assign d[103: 96] = d03;
   assign d[ 95: 88] = d10;
   assign d[ 87: 80] = d11;
   assign d[ 79: 72] = d12;
   assign d[ 71: 64] = d13;
   assign d[ 63: 56] = d20;
   assign d[ 55: 48] = d21;
   assign d[ 47: 40] = d22;
   assign d[ 39: 32] = d23;
   assign d[ 31: 24] = d30;
   assign d[ 23: 16] = d31;
   assign d[ 15:  8] = d32;
   assign d[  7:  0] = d33;

      
endmodule

