//------------------------------------------------------------
// encrypt_penguin.sv
// Encrypt Penguin in both ECB and CTR modes
//------------------------------------------------------------

parameter DATA_LENG = 10584;

bit [127:0] tx_d [0:DATA_LENG-1];

initial
  begin

     $readmemh("../inputs/penguin.blk", tx_d);

     //--------------------------------------------------
     rst = 1;
     din_valid = 0;
     din_type = 0;
     din_data = 0;
     crypto_mode = 0;

     init_test("ECB Penguin");

     repeat(10) @(posedge clk);
     rst = 0;
     msg_info("Letting DUT out of rst...");
     repeat(10) @(posedge clk);

     msg_info("Setting DUT to ECB");
     crypto_mode = 0;

     msg_info("Sending the KEY...");
     tx_data(128'h2b7e151628aed2a6abf7158809cf4f3c, 2'b10);
     @(posedge clk);
     din_valid = 0;
     din_type  = 0;
     din_data  = 0;
     @(posedge crypto_ready);

        
     fork

        // Transmit all of the data back to back
        begin
           for(int i=0; i<DATA_LENG; i++)
             begin
                msg_info("Sending the TX DATA...");
                tx_data(tx_d[i], 2'b00);
             end
           @(posedge clk);
           din_valid = 0;
           din_type  = 0;
           din_data  = 0;
        end

        // Receive all of the data back to back
        begin
           integer out_file;
           out_file = $fopen("penguin_ecb.blk","w");
           for(int i=0; i<DATA_LENG; i++)
             begin
                bit [127:0] d;
                bit         t;
                rx_data(d, t);
                $fwrite(out_file,"%h\n",d);
             end
           $fclose(out_file);
        end
           
     join
     repeat(10) @(posedge clk);


     //--------------------------------------------------
     rst = 1;
     din_valid = 0;
     din_type = 0;
     din_data = 0;
     crypto_mode = 0;

     init_test("CTR Penguin");

     repeat(10) @(posedge clk);
     rst = 0;
     msg_info("Letting DUT out of rst...");
     repeat(10) @(posedge clk);

     msg_info("Setting DUT to CTR");
     crypto_mode = 1;

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
           for(int i=0; i<DATA_LENG; i++)
             begin
                msg_info("Sending the TX DATA...");
                tx_data(tx_d[i], 2'b00);
             end
           @(posedge clk);
           din_valid = 0;
           din_type  = 0;
           din_data  = 0;
        end

        // Receive all of the data back to back
        begin
           integer out_file;
           out_file = $fopen("penguin_ctr.blk","w");
           for(int i=0; i<DATA_LENG; i++)
             begin
                bit [127:0] d;
                bit         t;
                rx_data(d, t);
                $fwrite(out_file,"%h\n",d);
             end
           $fclose(out_file);
        end
           
     join
     repeat(10) @(posedge clk);

     
     end_test();
  end


