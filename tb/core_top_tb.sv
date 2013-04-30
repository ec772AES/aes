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
  logic [31:0] din_data, dout_data;
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

    initial
        begin
            #50000
                $finish;
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
  `include "stim.v"


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
  // tx_data
  // Send data into the DUT
  //------------------------------------------------------------
  task tx_data (input bit [127:0] tx_data, bit [1:0] tx_type);
     msg_info($sformatf("Transmitting type=%b, data=0x%h", tx_type, tx_data));
     repeat(4)
       begin
          @(posedge clk);
          din_valid = 1;
          din_type  = tx_type;
          din_data  = tx_data[127:96];
          tx_data   = {tx_data[95:0], 32'h0};
       end
  endtask

  //------------------------------------------------------------
  // rx_data
  // Get data from the DUT
  //------------------------------------------------------------
  task rx_data (output bit [127:0] rx_data, bit rx_type);
     repeat(4)
       begin
          @(negedge clk);
          while (~dout_valid)
            begin
               @(posedge dout_valid);
               @(negedge clk);
            end
          rx_type   = dout_type;
          rx_data   = {rx_data[95:0], dout_data};
       end
     msg_info($sformatf("Receiving type=%b, data=0x%h", rx_type, rx_data));
  endtask

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