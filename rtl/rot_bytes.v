//--------------------------------------------------
// Florian Raudies
// EC772 - Spring 2013
//--------------------------------------------------

module rot_bytes 
  (
   input  [31:0] din,
   output [31:0] dout
   );
	
	/* a cyclic byte-wise left shift */
	dout = [din[23:0] din[31:24]];
	  
endmodule
