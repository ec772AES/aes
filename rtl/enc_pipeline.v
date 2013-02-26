//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module enc_pipeline
  (
   input          clk,
   input          rst,
   input  [127:0] rkey,
   input  [3:0]   addr,
   input  [127:0] din,
   output [127:0] dout
   );

  wire [127:0] rnd1, rnd2, rnd3,
               rnd4, rnd5, rnd6,
               rnd7, rnd8, rnd9;
  
  enc_round #(4'd1)
    u_round_1
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (din),
       .dout (rnd1));
  
  enc_round #(4'd2)
    u_round_2
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd1),
       .dout (rnd2));
  
  enc_round #(4'd3)
    u_round_3
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd2),
       .dout (rnd3));
  
  enc_round #(4'd4)
    u_round_4
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd3),
       .dout (rnd4));
  
  enc_round #(4'd5)
    u_round_5
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd4),
       .dout (rnd5));
  
  enc_round #(4'd6)
    u_round_6
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd5),
       .dout (rnd6));
  
  enc_round #(4'd7)
    u_round_7
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd6),
       .dout (rnd7));
  
  enc_round #(4'd8)
    u_round_8
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd7),
       .dout (rnd8));
  
  enc_round #(4'd9)
    u_round_9
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd8),
       .dout (rnd9));
  
  enc_round_last #(4'd10)
    u_round_10
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (rnd9),
       .dout (dout));
  
   
endmodule

