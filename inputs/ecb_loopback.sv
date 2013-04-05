//------------------------------------------------------------
// ecb_loopback.sv
// ECB Loopback
//------------------------------------------------------------
`include "kat_inputs.vh"

initial
  begin
     rst = 1;
	 din_valid = 0;
	 din_type = 0;
	 din_data = 0;
	 crypto_mode = 0;

	 init_test("ECB Loopback");

	 for(int i = 0; i < NUM_TESTS; i++)
	 begin
	   rst = 1;
	   din_valid = 0;
	   din_type = 0;
	   din_data = 0;
	   crypto_mode = 0;

	   $display("--------------------------");
	   $display("Test Number #%d", i+1);
	   $display("--------------------------");

	   repeat(10) @(posedge clk);
	   rst = 0;
	   msg_info("Letting DUT out of rst...");
	   repeat(10) @(posedge clk);

	   msg_info("Setting DUT to ECB");
	   crypto_mode = 0;


	   // Simple Loopback test
	   begin
	      bit [127:0]        rx_d;
	      bit                rx_t;


	      msg_info("Sending the KEY...");
	      tx_data(kat_key_vector[i], 2'b10);
	      @(posedge clk);
	      din_valid = 0;
	      din_type  = 0;
	      din_data  = 0;
	      @(posedge crypto_ready);

	      msg_info("Sending the ENCRYPT DATA...");
	      tx_data(kat_plain_vector[i], 2'b00);
	      @(posedge clk);
	      din_valid = 0;
	      din_type  = 0;
	      din_data  = 0;

	      msg_info("Waiting for ENCRYPTED DATA...");
	      rx_data(rx_d, rx_t);
	      if (rx_t != 0)
	      begin
		    error_count++;
			msg_error("RX ENCRYPTED DATA type is wrong!");
	      end

		  if(rx_d != kat_cipher_vector[i])
		  begin
		    error_count++;
			msg_error("Encrypted Data Does Not Match!");
		  end

	      msg_info("Sending the DECRYPT DATA...");
	      tx_data(rx_d, 2'b01);
	      @(posedge clk);
	      din_valid = 0;
	      din_type  = 0;
	      din_data  = 0;

	      msg_info("Waiting for DECRYPTED DATA...");
	      rx_data(rx_d, rx_t);
	      if (rx_t != 1)
	      begin
		    error_count++;
			msg_error("RX DECRYPTED DATA type is wrong!");
	      end

	      if (rx_d != kat_plain_vector[i])
	      begin
		    error_count++;
			msg_error("Test Data does not match at end!");
	      end
	    end


       repeat(10) @(posedge clk);
       end //end for loop
     end_test();
  end


