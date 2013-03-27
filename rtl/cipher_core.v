//--------------------------------------------------
// Ben Humphries
// EC772 - Spring 2013
//--------------------------------------------------

module cipher_core
  (
   input           clk,
   input           rst,

   // Stream In IF
   input           vin,
   input  [1:0]    tin,
   input  [127:0]  din,
   
   // Stream Out IF
   output reg          vout,
   output reg          tout,
   output reg  [127:0] dout,

   // Key Expand IF
   input           keyed,
   input  [3:0]    addr,
   input  [127:0]  rkey,

   // Core Top IF
   input           crypto_mode,
   output reg      crypto_ready
   );

  
  parameter TYPE_IN_ENC  = 2'b00;
  parameter TYPE_IN_DEC  = 2'b01;
  parameter TYPE_IN_KEY  = 2'b10;
  parameter TYPE_IN_IV   = 2'b11;

  parameter TYPE_OUT_ENC = 1'b0;
  parameter TYPE_OUT_DEC = 1'b1;
  
  parameter MODE_ECB     = 1'b0;
  parameter MODE_CTR     = 1'b1;

  wire [127:0] enc_dout, dec_dout;
  wire [127:0] ctrl_dout;
  wire         ctrl_vout, ctrl_tout;

  reg [127:0] crypto_din;
  reg [127:0] ctrl_din;
  reg         ctrl_vin;
  reg         ctrl_tin;
  
  reg [127:0] iv_enc;
  reg [127:0] iv_dec;
  
  reg         crypto_mode_r;

  
  // --- Cipher Controller ---
  // Register the crypto_mode and crypto_ready
  always @(posedge clk)
    if (rst)
      begin
        crypto_mode_r <= 1'b0;
        crypto_ready  <= 1'b0;
      end
    else
      if (~crypto_ready & keyed)
        begin
          crypto_mode_r <= crypto_mode;
          crypto_ready  <= 1'b1;
        end
      else
        begin
          crypto_mode_r <= crypto_mode_r;
          crypto_ready  <= crypto_ready;
        end


  // --- Cipher Data In Controller ---
  // Select valid, type, & data for the pipelines
  always @(*)
    begin

      // Crypto Pipelines
      if (crypto_mode_r == MODE_ECB)
        crypto_din = din;
      else
        case (tin)
          TYPE_IN_ENC: crypto_din = iv_enc;
          TYPE_IN_DEC: crypto_din = iv_dec;
          TYPE_IN_KEY: crypto_din = 128'd0;
          TYPE_IN_IV : crypto_din = 128'd0;
        endcase

      // Control Pipeline Data
      if (crypto_mode_r == MODE_ECB)
        ctrl_din = 128'h0;
      else
        case (tin)
          TYPE_IN_ENC,
          TYPE_IN_DEC: crypto_din = din;
          TYPE_IN_KEY: crypto_din = 128'd0;
          TYPE_IN_IV : crypto_din = 128'd0;
        endcase

      // Control Pipeline Type
      ctrl_tin = tin[0];

      // Control Pipeline Valid
      if (crypto_ready)
        ctrl_vin = vin;
      else
        ctrl_vin = 1'b0;
      
    end

  // Register the Encrypt Initialization Vector
  always @(posedge clk)
    if (rst)
      iv_enc <= 128'd0;
    else
      if (vin & (tin == TYPE_IN_IV))
        iv_enc <= din;
      else
        if (vin & (tin == TYPE_IN_ENC))
          iv_enc <= iv_enc + 128'd1;
        else
          iv_enc <= iv_enc;

  // Register the Decrypt Initialization Vector
  always @(posedge clk)
    if (rst)
      iv_dec <= 128'd0;
    else
      if (vin & (tin == TYPE_IN_IV))
        iv_dec <= din;
      else
        if (vin & (tin == TYPE_IN_DEC))
          iv_dec <= iv_dec + 128'd1;
        else
          iv_dec <= iv_dec;
  

  // --- Pipelines ---
  // Instanciate the encrypt, decrypt, & control pipelines
  enc_pipeline
    u_enc_pipeline
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (crypto_din),
       .dout (enc_dout));

  dec_pipeline
    u_dec_pipeline
      (.clk  (clk),
       .rst  (rst),
       .rkey (rkey),
       .addr (addr),
       .din  (crypto_din),
       .dout (dec_dout));

  ctrl_pipeline
    u_ctrl_pipeline
      (.clk  (clk),
       .rst  (rst),
       .vin  (ctrl_vin),
       .tin  (ctrl_tin),
       .din  (ctrl_din),
       .vout (ctrl_vout),
       .tout (ctrl_tout),
       .dout (ctrl_dout));


  // --- Cipher Data Out Controller ---
  // Register the Type, Valid, and Data Out
  always @(posedge clk)
    if (rst)
      begin
         tout <= 0;
         vout <= 0;
         dout <= 128'd0;
      end
    else
      begin
         tout <= ctrl_tout;
         vout <= ctrl_vout;
         
         if (ctrl_vout)
           if (crypto_mode_r == MODE_ECB)
             if (ctrl_tout == TYPE_OUT_ENC)
               dout <= enc_dout;
             else // ECB, DEC
               dout <= dec_dout;
           else // CTR, ENC/DEC
             dout <= enc_dout ^ ctrl_dout;
         else
           dout <= 128'd0;
      end
  
endmodule

