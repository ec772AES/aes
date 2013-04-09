//------------------------------------------------------------
// ctr_loopback.sv
// CTR Loopback
//------------------------------------------------------------
                   
initial
  begin
     rst = 1;
     din_valid = 0;
     din_type = 0;
     din_data = 0;
     crypto_mode = 0;

     init_test("CTR Loopback");

     repeat(10) @(posedge clk);
     rst = 0;
     msg_info("Letting DUT out of rst...");
     repeat(10) @(posedge clk);

     msg_info("Setting DUT to CTR");
     crypto_mode = 1;


     // Simple Loopback test
     begin
        bit [127:0] pt_d[$];
        bit [127:0] ct_d[$];
        
        bit [127:0] rx_d[$];
        bit         rx_t[$];
        
        bit [127:0] tx_d[$];
        bit [  1:0] tx_t[$];

        
        // Plaintext Data
        pt_d.push_back(128'h6bc1bee22e409f96e93d7e117393172a);
        pt_d.push_back(128'hae2d8a571e03ac9c9eb76fac45af8e51);
        pt_d.push_back(128'h30c81c46a35ce411e5fbc1191a0a52ef);
        pt_d.push_back(128'hf69f2445df4f9b17ad2b417be66c3710);
        
        // Ciphertext Data
        ct_d.push_back(128'h874d6191b620e3261bef6864990db6ce);
        ct_d.push_back(128'h9806f66b7970fdff8617187bb9fffdff);
        ct_d.push_back(128'h5ae4df3edbd5d35e5b4f09020db03eab);
        ct_d.push_back(128'h1e031dda2fbe03d1792170a0f3009cee);

        
        // Transmit Data
        foreach (pt_d[i])
          begin
             tx_d.push_back(pt_d[i]);
             tx_t.push_back(2'b00);
          end
        foreach (ct_d[i])
          begin
             tx_d.push_back(ct_d[i]);
             tx_t.push_back(2'b01);
          end


        // Receive Data
        foreach (ct_d[i])
          begin
             rx_d.push_back(ct_d[i]);
             rx_t.push_back(1'b0);
          end
        foreach (pt_d[i])
          begin
             rx_d.push_back(pt_d[i]);
             rx_t.push_back(1'b1);
          end
        
        
        msg_info("Sending the KEY...");
        tx_data(128'h2b7e151628aed2a6abf7158809cf4f3c, 2'b10);
        @(posedge clk);
        din_valid = 0;
        din_type  = 0;
        din_data  = 0;
        @(posedge crypto_ready);

        msg_info("Sending the Initial Counter...");
        tx_data(128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff, 2'b11);

        
        fork

           // Transmit all of the data back to back
           begin
              for(int i=0; i<tx_d.size(); i++)
                begin
                   msg_info("Sending the TX DATA...");
                   tx_data(tx_d[i], tx_t[i]);
                end
              @(posedge clk);
              din_valid = 0;
              din_type  = 0;
              din_data  = 0;
           end

           // Receive all of the data back to back
           begin
              for(int i=0; i<rx_d.size(); i++)
                begin
                   bit [127:0] d;
                   bit         t;
                   rx_data(d, t);
                   if (rx_t[i] != t)
                     begin
                        msg_error($sformatf("RX Data Type Does Not Match expected! - %0b", rx_t[i]));
                     end
                   if(rx_d[i] != d)
                     begin
                        msg_error($sformatf("RX Data Does Not Match expected! - 0x%h", rx_d[i]));
                     end
                end
           end
           
        join
     end


     repeat(10) @(posedge clk);

     end_test();
  end


