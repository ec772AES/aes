//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module stream_in
  (
   input              clk,
   input              rst,
   input              vin,
   input      [1:0]   tin,
   input      [15:0]  din,
   output             vout,
   output reg [1:0]   tout,
   output reg [127:0] dout
   );
  
  reg [2:0]       counter, counter_r;
  reg [1:0]       tin_r;
  

  // Register the output data
  always @(posedge clk)
    if (rst)
      dout <= 128'd0;
    else
      if (vin)
        dout <= {dout[111:0], din};
      else
        dout <= dout;

  
  // Generate output valid
  assign vout = (counter == 3'b000) & (counter_r == 3'b111);

  
  // Register the input type
  always @(posedge clk)
    if (rst)
      tin_r <= 2'b00;
    else
      if (vin & (counter == 3'b000))
        tin_r <= tin;
      else
        tin_r <= tin_r;

  
  // Register output type
  always @(posedge clk)
    if (rst)
      tout <= 2'b00;
    else
      if (counter == 3'b111)
        tout <= tin_r;
      else
        tout <= tout;


  // Register the counter & registered counter
  always @(posedge clk)
    if (rst)
      begin
        counter   <= 4'd0;
        counter_r <= 4'd0;
      end
    else
      begin
        // increment the counter on valid in
        if (vin)
          counter <= counter + 4'd1;
        else
          counter <= counter;

        // register the counter
        counter_r <= counter;
      end
  
  
endmodule

