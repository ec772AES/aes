//------------------------------------------------------------
// core_top_tb.v
//
//------------------------------------------------------------


`timescale 1ns/10ps


module core_top_tb;

  // DUT signals
  logic         clk, rst;
  logic         din_valid, dout_valid, dout_type;
  logic [1:0]   din_type;
  logic [15:0] din_data, dout_data;
  logic         crypto_mode, crypto_ready;

  // TB signals
  int warning_count;
  int error_count;
  

  // Default signals and generate a clock
  initial
    begin
      clk         = 0;
      rst         = 1;
      din_valid   = 0;
      din_type    = 0;
      din_data    = 0;
      crypto_mode = 0;

      forever
        #1 clk = ~clk;
    end

  
  // Conditionally dump waves when needed
  `ifdef DUMP_WAVES
  initial
    begin
      $dumpvars;
      $dumpall;
      $dumpfile("waves.shm");
      $stop;
    end
  `endif
  

  // Include the test file
  initial
    begin
      #100
      init_test("Example Test");
      #10;
      rst = 0;
      msg_info("Letting DUT out of rst");
      
      crypto_mode = 0;
      din_type = 2'b10;
      din_data = 16'h2b7e;
      din_valid = 1;
      
      #2 din_data = 16'h1516;
      #2 din_data = 16'h28ae;
      #2 din_data = 16'hd2a6;
      #2 din_data = 16'habf7;
      #2 din_data = 16'h1588;
      #2 din_data = 16'h09cf;
      #2 din_data = 16'h4f3c;
      #2 din_valid = 0;
      din_data = 16'h0000;
      
  end
  
  always @(posedge crypto_ready)
  begin
      din_type = 2'b00;
      din_valid = 1;
      din_data = 16'h0011;
			#2 din_data = 16'h2233;
			#2 din_data = 16'h4455;
			#2 din_data = 16'h6677;
			#2 din_data = 16'h8899;
			#2 din_data = 16'haabb;
			#2 din_data = 16'hccdd;
			#2 din_data = 16'heeff;
			#2 din_valid = 0;
      
      
      #50;
      end_test();
  end


  // Instanciate the DUT
  core_top
    u_dut
      (.clk            (clk),
       .rst            (rst),
       // Stream In IF
       .data_in_valid  (din_valid),
       .data_in_type   (din_type),
       .data_in        (din_data),
       // Stream Out IF
       .data_out_valid (dout_valid),
       .data_out_type  (dout_type),
       .data_out       (dout_data),
       // Cipher Core IF
       .crypto_mode    (crypto_mode),
       .crypto_ready   (crypto_ready));


  // TB Tasks & Functions

  //------------------------------------------------------------
  // init_test
  // Called at the beginning of a test to initialize it.
  //------------------------------------------------------------
  task init_test (string name);
    $display("------------------------------------------------------------");
    $display("  INITIALIZE TEST: %s", name);
    $display("------------------------------------------------------------");
    warning_count = 0;
    error_count   = 0;
  endtask

  //------------------------------------------------------------
  // msg_info
  // Called to display a message
  //------------------------------------------------------------
  task msg_info (string msg);
    $display("@%0d INFO: %s", $time, msg);
  endtask

  //------------------------------------------------------------
  // msg_warn
  // Called to update the warning count with a message
  //------------------------------------------------------------
  task msg_warn (string msg);
    $display("@%0d WARNING: %s", $time, msg);
    warning_count++;
  endtask

  //------------------------------------------------------------
  // msg_error
  // Called to update the error count with a message
  //------------------------------------------------------------
  task msg_error (string msg);
    $display("@%0d ERROR: %s", $time, msg);
    error_count++;
  endtask

  //------------------------------------------------------------
  // msg_fatal
  // Called to terminate the simulation with a fatal message
  //------------------------------------------------------------
  task msg_fatal (string msg);
    $display("@%0d FATAL: %s", $time, msg);
    error_count++;
    end_test();
  endtask
  
  //------------------------------------------------------------
  // end_test
  // Called at the end of a test to finish it.
  //------------------------------------------------------------
  task end_test ();
    $display("------------------------------------------------------------");
    $display("  END TEST");
    $display("");
    $display("       # Warnings: %0d", warning_count);
    $display("       # Errors  : %0d", error_count);
    $display("");
    if (error_count > 0)
      begin
        $display("FFFFFF   A    IIIII L     ");
        $display("F       A A     I   L     ");
        $display("FFFFF  A   A    I   L     ");
        $display("F     AAAAAAA   I   L     ");
        $display("F     A     A   I   L     ");
        $display("F     A     A IIIII LLLLL ");
      end
    else
      begin
        $display("PPPPP    A    SSSSS SSSSS ");
        $display("P    P  A A   S     S     ");
        $display("PPPPP  A   A  SSSSS SSSSS ");
        $display("P     AAAAAAA     S     S ");
        $display("P     A     A     S     S ");
        $display("P     A     A SSSSS SSSSS ");
      end
    $display("------------------------------------------------------------");
    $finish;
  endtask
  
endmodule
