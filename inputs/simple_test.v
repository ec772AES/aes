
initial
  begin
     fir_in = 0;
     w_1 = 0;
     w_2 = 0;
     w_3 = 0;
     $display("Hello World");
     #100;
     fir_in = 1;
     #1000;
     $display("Goodbye world");
     $finish;
  end