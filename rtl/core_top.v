//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module core_top
  (
   input          clk,
   input          rst,

   // Stream In IF
   input          data_in_valid,
   input [1:0]    data_in_type,
   input [15:0]   data_in,
   
   // Stream Out IF
   output         data_out_valid,
   output         data_out_type,
   output [15:0]  data_out,

   // Cipher Core IF
   input          crypto_mode,
   output         crypto_ready
   );

  wire [127:0] stream_in_data,  stream_out_data;
  wire         stream_in_valid, stream_out_valid;
  wire [1:0]   stream_in_type;
  wire         stream_out_type;
  
  wire         keyed;
  wire [3:0]   key_addr;
  wire [127:0] key;
  
  stream_in
    u_stream_in
      (.clk  (clk),
       .rst  (rst),
       .vin  (data_in_valid),
       .tin  (data_in_type),
       .din  (data_in),
       .vout (stream_in_valid),
       .tout (stream_in_type),
       .dout (stream_in_data));

  cipher_core
    u_cipher_core
      (.clk   (clk),
       .rst   (rst),
       .vin   (stream_in_valid),
       .tin   (stream_in_type),
       .din   (stream_in_data),
       .vout  (stream_out_valid),
       .tout  (stream_out_type),
       .dout  (stream_out_data),
       .keyed (keyed),
       .addr  (key_addr),
       .rkey  (key),
       .crypto_mode  (crypto_mode),
       .crypto_ready (crypto_ready));
  
  key_expansion
    u_key_expansion
      (.clk          (clk),
       .rst          (rst),
       .key_in_valid (stream_in_valid),
       .key_in_type  (stream_in_type),
       .key_in       (stream_in_data),
       .key_out      (key),
       .key_addr     (key_addr),
       .key_loaded   (keyed));

  stream_out
    u_stream_out
      (.clk  (clk),
       .rst  (rst),
       .vin  (stream_out_valid),
       .tin  (stream_out_type),
       .din  (stream_out_data),
       .vout (data_out_valid),
       .tout (data_out_type),
       .dout (data_out));
  
  
endmodule

