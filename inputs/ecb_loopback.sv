//------------------------------------------------------------
// ecb_loopback.sv
// ECB Loopback
//------------------------------------------------------------

initial
  begin
     init_test("ECB Loopback");
       
     repeat(10) @(posedge clk);
     rst = 0;
     msg_info("Letting DUT out of rst...");
     repeat(10) @(posedge clk);

     msg_info("Setting DUT to ECB");
     crypto_mode = 0;
     

     // Simple Loopback test
     begin
        static bit [127:0] test_key  = 128'h0001_0203_0405_0607_0809_0a0b_0c0d_0e0f;
        static bit [127:0] test_data = 128'h0011_2233_4455_6677_8899_aabb_ccdd_eeff;
        bit [127:0]        rx_d;
        bit                rx_t;
          

        msg_info("Sending the KEY...");
        tx_data(test_key, 2'b10);
        @(posedge clk);
        din_valid = 0;
        din_type  = 0;
        din_data  = 0;
        @(posedge crypto_ready);

        msg_info("Sending the ENCRYPT DATA...");
        tx_data(test_data, 2'b00);
        @(posedge clk);
        din_valid = 0;
        din_type  = 0;
        din_data  = 0;

        msg_info("Waiting for ENCRYPTED DATA...");
        rx_data(rx_d, rx_t);
        if (rx_t != 0)
          msg_error("RX ENCRYPTED DATA type is wrong!");
          
        msg_info("Sending the DECRYPT DATA...");
        tx_data(rx_d, 2'b01);
        @(posedge clk);
        din_valid = 0;
        din_type  = 0;
        din_data  = 0;

        msg_info("Waiting for DECRYPTED DATA...");
        rx_data(rx_d, rx_t);
        if (rx_t != 1)
          msg_error("RX DECRYPTED DATA type is wrong!");

        if (rx_d != test_data)
          msg_error("Test Data does not match at end!");
     end

          
     repeat(10) @(posedge clk);
     end_test();
  end


   