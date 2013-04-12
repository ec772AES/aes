#=========================================================================
# TCL Script File for Synthesis using Cadence RTL Compiler
#-------------------------------------------------------------------------

#

# The makefile will generate various variables which we now read in
# and then display

set hdl_search_path ../rtl

# The library setup is kept in a separate tcl file which we now source

set_attribute library  ../../NangateOpenCellLibrary_typical_ccs.lib

# These two commands read in your verilog source and elaborate it
read_hdl {../rtl/key_expansion.v ../rtl/key_expansion_logic.v ../rtl/rcon.v ../rtl/sbox.v} -top ../rtl/key_expansion.v -sv

elaborate

# This command will check your design for any errors

check_design > synth_check_design.rpt

# We now load in the constraints file

set clk_input [define_clock -period 2000 -name clk_input clk]
external_delay -input 0 -clock $clk_input -name in_con [find /des* -port ports_in/*]
external_delay -output 0 -clock $clk_input -name out_con [find /des* -port ports_out/*]

# This actually does the synthesis. The -effort option indicates
# how much time the synthesizer should spend optimizing your design to
# gates. Setting it to high means synthesis will take longer but will
# probably produce better results.

synthesize -to_mapped -effort medium

# We write out the results as a verilog netlist

write -mapped > key_expansion_netlist.v

# We create a timing report for the worst case timing path,
# an area report for each reference in the heirachy and a DRC report

report timing > timing.rpt
report area > cell_area.rpt
report gates > gate_area.rpt
report design_rules key_expansion > design_rule_violations.rpt

# Used to exit the RTL Compiler

exit