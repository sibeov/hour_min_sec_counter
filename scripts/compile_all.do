package require fileutil

if {[batch_mode]} {
  onerror {abort all; exit -f -code 1}
  onbreak {abort all; exit -f}
} else {
  onerror {abort all}
}

# ---------- Fileutil example -----------
# foreach file [fileutil::findByPattern $basepath *.tcl] {
#     source $file
# }

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