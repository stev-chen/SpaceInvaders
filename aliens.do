# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ps/1ps aliens.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver datapath

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {clk} 0 0, 1 10 -repeat 20ps
force {resetn} 0 0, 1 20
force {data_in} 11111
force {ld_status} 0 1, 1 10, 0 20
force {count_enable} 0 1, 1 10
force {ld_pixel} 0 1, 1 10
force {x_move} 1
force {y_move} 1
force {x_enable} 0
force {y_enable} 0
run 1000ps