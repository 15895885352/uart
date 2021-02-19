quit -sim
cd D:/gaop/SIM/x1spi
vlib work
vmap work work
#
# QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# construct paths to the files required to simulate the IP in your Quartus
# project. By default, the IP script assumes that you are launching the
# simulator from the IP script location. If launching from another
# location, set QSYS_SIMDIR to the output directory you specified when you
# generated the IP script, relative to the directory from which you launch
# the simulator.
#
set QSYS_SIMDIR ./cmdarrar10fifo/cmdarrar10fifo/sim
#
# Source the generated IP simulation script.
source $QSYS_SIMDIR/mentor/msim_setup.tcl
#
# Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# set USER_DEFINED_VHDL_COMPILE_OPTIONS <compilation options for VHDL>
# set USER_DEFINED_VERILOG_COMPILE_OPTIONS <compilation options for Verilog>
#
# Call command to compile the Quartus EDA simulation library.
# dev_com
#
# Call command to compile the Quartus-generated IP simulation files.
com
#
# Add commands to compile all design files and testbench files, including
# the top level. (These are all the files required for simulation other
# than the files compiled by the Quartus-generated IP simulation script)
#
# set    QUARTUS_INSTALL_DIR "C:/intelfpga/17.1/quartus/"
# vlib  ./libraries/altera_mf 
# vmap altera_mf ./libraries/altera_mf   
# vlog  C:/intelfpga/17.1/quartus/eda/sim_lib/altera_mf.v      -work altera_mf  
   
# vlib  ./libraries/lpm 
# vmap lpm ./libraries/lpm   
# vlog  C:/intelfpga/17.1/quartus/eda/sim_lib/220model.v      -work lpm 
   
# vlib  ./libraries/altera_primitive 
# vmap altera_primitive ./libraries/altera_primitive   
# vlog  C:/intelfpga/17.1/quartus/eda/sim_lib/altera_primitives.v      -work altera_primitive 
   
# vlib  ./libraries/cyclone 
# vmap cyclone ./libraries/cyclone   
# vlog  C:/intelfpga/17.1/quartus/eda/sim_lib/cycloneiv_atoms.v      -work cyclone 

# vlog  -novopt -incr -work work "./tb/addr_trans.v"
# vlog  -novopt -incr -work work "./tb/WrPageRam256x8bit.v"
# vlog  -novopt -incr -work work "./tb/x1spi.v"
# vlog  -novopt -incr -work work "./tb/tb.v"

vlog  -novopt -incr -work work "./tb/uart_rx.v"
vlog  -novopt -incr -work work "./tb/uart_tx.v"
vlog  -novopt -incr -work work "./tb/uart.v"
#
# Set the top-level simulation or testbench module/entity name, which is
# used by the elab command to elaborate the top level.
#
set TOP_LEVEL_NAME uart
  set USER_DEFINED_ELAB_OPTIONS " -L altera_mf   -L lpm   -L altera_mf   -L altera_primitive   -L cyclone  "
#
# Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
#
# Call command to elaborate your design and testbench.
elab_debug
#
# Run the simulation.
log -r  /*
do uart.do

run 2.5us
#



