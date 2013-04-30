//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module stream_out
  (
   input              clk,
   input              rst,
   input              vin,
   input              tin,
   input      [127:0] din,
   output             vout,
   output reg         tout,
   output     [31:0]  dout
   );

   reg [127:0]        data;
   reg [3:0]          valid;
  

  // Register the input data & type
  always @(posedge clk)
    if (rst)
      begin
        data <= 128'd0;
        tout <= 1'b0;
      end
    else
      if (vin)
        begin
          data <= din;
          tout <= tin;
        end
      else
        begin
          data <= {data[95:0], 32'd0};
          tout <= tout;
        end
          

  // Generate output data
  assign dout = data[127:96];

  
  // Generate output valid
  assign vout = valid[0];


  // Register valid
  always @(posedge clk)
    if (rst)
      valid <= 4'd0;
    else
      if (vin)
        valid <= 4'hF;
      else
        valid <= {1'b0, valid[3:1]};
  
  
endmodule

