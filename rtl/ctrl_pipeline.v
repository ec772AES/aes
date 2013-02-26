//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module ctrl_pipeline
  (
   input          clk,
   input          rst,
   input          vin,
   input          tin,
   input  [127:0] din,
   output reg         vout,
   output reg         tout,
   output reg [127:0] dout
   );

  reg [129:0] rnd1, rnd2, rnd3,
              rnd4, rnd5, rnd6,
              rnd7, rnd8, rnd9;

  // Register the valid, type, and data
  always @(posedge clk)
    if (rst)
      begin
        rnd1 <= 130'd0;
        rnd2 <= 130'd0;
        rnd3 <= 130'd0;
        rnd4 <= 130'd0;
        rnd5 <= 130'd0;
        rnd6 <= 130'd0;
        rnd7 <= 130'd0;
        rnd8 <= 130'd0;
        rnd9 <= 130'd0;
        vout <= 1'd0;
        tout <= 1'd0;
        dout <= 128'd0;
      end
    else
      begin
        rnd1 <= {vin, tin, din};
        rnd2 <= rnd1;
        rnd3 <= rnd2;
        rnd4 <= rnd3;
        rnd5 <= rnd4;
        rnd6 <= rnd5;
        rnd7 <= rnd6;
        rnd8 <= rnd7;
        rnd9 <= rnd8;
        vout <= rnd9[129];
        tout <= rnd9[128];
        dout <= rnd9[127:0];
      end
  
   
endmodule

