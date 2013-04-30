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
   input      [31:0]  din,
   output             vout,
   output reg [1:0]   tout,
   output reg [127:0] dout
   );
  
  reg [1:0]       counter, counter_r;
  reg [1:0]       tin_r;
  

  // Register the output data
  always @(posedge clk)
    if (rst)
      dout <= 128'd0;
    else
      if (vin)
        dout <= {dout[95:0], din};
      else
        dout <= dout;

  
  // Generate output valid
  assign vout = (counter == 2'b00) & (counter_r == 2'b11);

  
  // Register the input type
  always @(posedge clk)
    if (rst)
      tin_r <= 2'b00;
    else
      if (vin & (counter == 2'b00))
        tin_r <= tin;
      else
        tin_r <= tin_r;

  
  // Register output type
  always @(posedge clk)
    if (rst)
      tout <= 2'b00;
    else
      if (counter == 2'b11)
        tout <= tin_r;
      else
        tout <= tout;


  // Register the counter & registered counter
  always @(posedge clk)
    if (rst)
      begin
        counter   <= 2'd0;
        counter_r <= 2'd0;
      end
    else
      begin
        // increment the counter on valid in
        if (vin)
          counter <= counter + 2'd1;
        else
          counter <= counter;

        // register the counter
        counter_r <= counter;
      end
  
  
endmodule

