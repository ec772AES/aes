//------------------------------------------------------------
// test.v
// <Decription about what the test does>
//------------------------------------------------------------

initial
  begin
    init_test("Example Test");
    #10;
    rst = 0;
    msg_info("Letting DUT out of rst");
    #100;
    end_test();
  end