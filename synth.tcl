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
read_hdl {../rtl/add_rkey.v ../rtl/cipher_core.v ../rtl/convert_aes_block.v ../rtl/core_top.v ../rtl/ctrl_pipeline.v ../rtl/dec_pipeline.v ../rtl/dec_round.v ../rtl/dec_round_last.v ../rtl/enc_pipeline.v ../rtl/enc_round.v ../rtl/enc_round_last.v ../rtl/gf_mul2.v ../rtl/inv_mix_bytes.v ../rtl/inv_mix_cols.v ../rtl/inv_sbox.v ../rtl/inv_shift_rows.v ../rtl/inv_sub_bytes.v ../rtl/key_expansion.v ../rtl/key_expansion_logic.v ../rtl/mix_bytes.v ../rtl/mix_cols.v ../rtl/rcon.v ../rtl/sbox.v ../rtl/shift_rows.v ../rtl/stream_in.v ../rtl/stream_out.v ../rtl/sub_bytes.v} -top ../rtl/core_top.v -sv

elaborate

# This command will check your design for any errors

check_design > synth_check_design.rpt

# We now load in the constraints file

set clk_input [define_clock -period 5000 -name clk_input clk]
external_delay -input 0 -clock $clk_input -name in_con [find /des* -port ports_in/*]
external_delay -output 0 -clock $clk_input -name out_con [find /des* -port ports_out/*]

# This actually does the synthesis. The -effort option indicates
# how much time the synthesizer should spend optimizing your design to
# gates. Setting it to high means synthesis will take longer but will
# probably produce better results.

synthesize -to_mapped -effort medium

# We write out the results as a verilog netlist

write -mapped > core_top_netlist.v

# We create a timing report for the worst case timing path,
# an area report for each reference in the heirachy and a DRC report

report timing > timing.rpt
report area > cell_area.rpt
report gates > gate_area.rpt
report design_rules core_top > design_rule_violations.rpt

# Used to exit the RTL Compiler

exit