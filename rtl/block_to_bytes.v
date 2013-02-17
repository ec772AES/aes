//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module block_to_bytes
  (
   input  [127:0] d,
   output [  7:0] d00, d01, d02, d03,
                  d10, d11, d12, d13,
                  d20, d21, d22, d23,
                  d30, d31, d32, d33
   );

   
   assign d00 = d[127:120];
   assign d01 = d[119:112];
   assign d02 = d[111:104];
   assign d03 = d[103: 96];
   assign d10 = d[ 95: 88];
   assign d11 = d[ 87: 80];
   assign d12 = d[ 79: 72];
   assign d13 = d[ 71: 64];
   assign d20 = d[ 63: 56];
   assign d21 = d[ 55: 48];
   assign d22 = d[ 47: 40];
   assign d23 = d[ 39: 32];
   assign d30 = d[ 31: 24];
   assign d31 = d[ 23: 16];
   assign d32 = d[ 15:  8];
   assign d33 = d[  7:  0];

      
endmodule

