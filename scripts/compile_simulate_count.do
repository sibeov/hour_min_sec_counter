if {[batch_mode]} {
  onerror {abort all; exit -f -code 1}
  onbreak {abort all; exit -f}
} else {
  onerror {abort all}
}

quit -sim

# Path and dir vars
quietly set root_path "../../.."
quietly set home_path ".."

quietly set src_path "$home_path/src"
quietly set tb_path "$home_path/tb"

quietly set com_lib_path "$root_path/lib"

# ---------- Compilation -----------
# Lib files
foreach lib_file [fileutil::findByPattern $com_lib_path *.vhd] {
  vcom -2008 $lib_file
}
# Src files
foreach src_file [fileutil::findByPattern $src_path *.vhd] {
  vcom -2008 -check_synthesis $src_file
}
# Testbench files
foreach tb_file [fileutil::findByPattern $tb_path *.vhd] {
  vcom -2008 $tb_file
}

# ---------- Simulation -----------
vsim hms_count_tb

add wave -noupdate -divider DUT_ips
add wave hms_count_tb/DUT/clk
add wave hms_count_tb/DUT/rst_n
add wave hms_count_tb/DUT/sec_o
add wave hms_count_tb/DUT/min_o
add wave hms_count_tb/DUT/hour_o
add wave -noupdate -divider DUT_sigs
add wave hms_count_tb/DUT/s_sec
add wave hms_count_tb/DUT/s_min
add wave hms_count_tb/DUT/s_hour

view wave -undock

configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -timelineunits ms
update

run -all

wave zoom full