
quit -sim

vlib work  

#mapping work library to current directory
#vmap [-help] [-c] [-del] [<logical_name>] [<path>]
vmap work  

#compile all .v files to work library
#-work <path>       Specify library WORK
#-vlog01compat      Ensure compatibility with Std 1364-2001
#-incr              Enable incremental compilation
#"rtl/*.v"          rtl directory all .v files, support relative path, need to add ""

#vlog
vlog -novopt  \
+incdir+../../project/src/lvds_7to1_rx \
../../project/src/lvds_7to1_rx/lvds_7to1_rx_top.v \
../../project/src/lvds_7to1_rx/LVDS71RX_1CLK8DATA.v \
../../project/src/lvds_7to1_rx/bit_align_ctl.v \
../../project/src/lvds_7to1_rx/word_align_ctl.v \
../../project/src/lvds_7to1_rx/gowin_rpll/LVDS_RX_rPLL.v \
../../project/src/lvds_7to1_rx/gowin_pllvr/LVDS_RX_PLLVR.v 

vlog -novopt  \
+incdir+../../project/src/lvds_7to1_tx \
../../project/src/lvds_7to1_tx/lvds_7to1_tx_top.v \
../../project/src/lvds_7to1_tx/ip_gddr71tx.v \
../../project/src/lvds_7to1_tx/gowin_rpll/LVDS_TX_rPLL.v \
../../project/src/lvds_7to1_tx/gowin_pllvr/LVDS_TX_PLLVR.v 

#testbench
vlog -novopt ../../tb/tb.v
vlog -novopt ../../tb/driver/*.v
vlog -novopt ../../tb/monitor/*.v
vlog -novopt ../../tb/prim_sim.v


#complie all .vhd files
#-work <path>       Specify library WORK
#-93                Enable support for VHDL 1076-1993
#-2002              Enable support for VHDL 1076-2002
#vcom

#simulate testbench top file
#-L <libname>                     Search library for design units instantiated from Verilog and for VHDL default component binding
#+nowarn<CODE | Number>           Disable specified warning message  (Example: +nowarnTFMPC)                      
#-t [1|10|100]fs|ps|ns|us|ms|sec  Time resolution limit VHDL default: resolution setting from .ini file) 
#                                 (Verilog default: minimum time_precision in the design)
#-novopt                          Force incremental mode (pre-6.0 behavior)

vsim +nowarnTFMPC -L work  -novopt -l tb.log work.tb 

#generate wave log format(WLF)......
log -r /*

#open wave window
view wave

#add simulation singals
do tb_wave.do

#set run time
run  -all



